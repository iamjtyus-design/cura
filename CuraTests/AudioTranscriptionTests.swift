import XCTest
@testable import CuraCore

@MainActor
final class AudioTranscriptionTests: XCTestCase {
    func testTranscriptionSuccessCreatesCuratedNote() async throws {
        let container = DependencyContainer.make(configuration: .development, processingStageDelayNanoseconds: 1)
        let model = PhaseOneViewModel(container: container)
        let session = try await saveAudioSession(in: container)

        await model.reloadForTesting()
        model.startCuratedNoteProcessing(for: session)
        try await waitForNote(sessionID: session.id, in: model)

        let note = try XCTUnwrap(model.note(for: session.id))
        XCTAssertEqual(note.generationStatus, .completed)
        XCTAssertFalse(note.transcript.isEmpty)
        XCTAssertEqual(note.transcriptSegments.count, 2)
        XCTAssertEqual(note.summary, note.smartSummary)
        XCTAssertEqual(note.keyPoints.count, 3)
        XCTAssertEqual(note.structuredActionItems.count, 3)
        XCTAssertEqual(model.selectedSession?.title, "Launch Checklist Field Memo")
        XCTAssertEqual(note.confirmedTitle, "Launch Checklist Field Memo")
        XCTAssertFalse(note.documentBlocks.isEmpty)
        XCTAssertFalse(model.shouldShowProcessing(for: try XCTUnwrap(model.selectedSession)))
    }

    func testTranscriptionFailurePreservesSessionAndCanRetry() async throws {
        let failing = MockTranscriptionProvider(stageDelayNanoseconds: 1, shouldFail: true)
        let container = DependencyContainer.make(configuration: .development, transcription: failing)
        let model = PhaseOneViewModel(container: container)
        let session = try await saveAudioSession(in: container)

        await model.reloadForTesting()
        model.startCuratedNoteProcessing(for: session)
        try await waitForNote(sessionID: session.id, in: model)

        let failedNote = try XCTUnwrap(model.note(for: session.id))
        XCTAssertEqual(failedNote.generationStatus, .failed)
        let preservedSession = try await container.sessions.fetch(id: session.id)
        let preservedSources = try await container.sources.fetchSources(for: session.id)
        XCTAssertNotNil(preservedSession)
        XCTAssertEqual(preservedSources.count, 1)

        let retryContainer = DependencyContainer.make(configuration: .development, processingStageDelayNanoseconds: 1)
        try await seed(session: session, source: try XCTUnwrap(preservedSources.first), into: retryContainer)
        let retryModel = PhaseOneViewModel(container: retryContainer)
        await retryModel.reloadForTesting()
        retryModel.retryCuratedNoteProcessing(for: session)
        try await waitForNote(sessionID: session.id, in: retryModel)
        XCTAssertEqual(retryModel.note(for: session.id)?.generationStatus, .completed)
    }

    func testTranscriptionCancellationDoesNotCreateCompletedNote() async throws {
        let slow = MockTranscriptionProvider(stageDelayNanoseconds: 500_000_000)
        let container = DependencyContainer.make(configuration: .development, transcription: slow)
        let model = PhaseOneViewModel(container: container)
        let session = try await saveAudioSession(in: container)

        await model.reloadForTesting()
        model.startCuratedNoteProcessing(for: session)
        model.cancelCuratedNoteProcessing(for: session.id)
        try await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertNil(model.note(for: session.id))
        XCTAssertEqual(model.curatedNoteProgress(for: session.id)?.status, .cancelled)
    }

    func testEmptyTranscriptDoesNotInventTitleOrActions() async throws {
        let empty = MockTranscriptionProvider(stageDelayNanoseconds: 1, shouldReturnEmptyTranscript: true)
        let container = DependencyContainer.make(configuration: .development, transcription: empty)
        let model = PhaseOneViewModel(container: container)
        let session = try await saveAudioSession(in: container)

        await model.reloadForTesting()
        model.startCuratedNoteProcessing(for: session)
        try await waitForNote(sessionID: session.id, in: model)

        let note = try XCTUnwrap(model.note(for: session.id))
        XCTAssertEqual(note.transcript, "")
        XCTAssertNil(note.suggestedTitle)
        XCTAssertTrue(note.structuredActionItems.isEmpty)
        XCTAssertEqual(note.title, "Audio Recording")
        XCTAssertEqual(model.selectedSession?.title, "Audio Recording")
    }

    func testMockTranscriptionDefaultDurationIsStagedButFast() async throws {
        let started = Date()
        _ = try await MockTranscriptionProvider().transcribe(
            session: CaptureSession(title: "Audio Recording", mode: .create),
            source: CaptureSource(sessionID: UUID(), sourceType: .liveAudio),
            progress: { _ in }
        )
        let elapsed = Date().timeIntervalSince(started)

        XCTAssertGreaterThanOrEqual(elapsed, 3)
        XCTAssertLessThan(elapsed, 6)
    }

    func testSuggestedTitleAcceptanceAndManualTitlePreservation() async throws {
        let container = DependencyContainer.make(configuration: .development, processingStageDelayNanoseconds: 1)
        let model = PhaseOneViewModel(container: container)
        var session = try await saveAudioSession(in: container)
        session.title = "My Manual Title"
        try await container.sessions.save(session)

        await model.reloadForTesting()
        model.startCuratedNoteProcessing(for: session)
        try await waitForNote(sessionID: session.id, in: model)

        let note = try XCTUnwrap(model.note(for: session.id))
        let sessionBeforeAccept = try await container.sessions.fetch(id: session.id)
        XCTAssertEqual(sessionBeforeAccept?.title, "My Manual Title")
        XCTAssertEqual(note.suggestedTitle, "Launch Checklist Field Memo")
        XCTAssertNil(note.confirmedTitle)

        await model.acceptSuggestedTitle(for: session, note: note, editedTitle: "Edited Launch Memo")
        let sessionAfterAccept = try await container.sessions.fetch(id: session.id)
        XCTAssertEqual(sessionAfterAccept?.title, "Edited Launch Memo")
        XCTAssertEqual(model.selectedSession?.title, "Edited Launch Memo")
        XCTAssertEqual(model.note(for: session.id)?.confirmedTitle, "Edited Launch Memo")
    }

    func testAutomaticTitleAppliesOnlyToUntouchedFallbackTitle() async throws {
        let container = DependencyContainer.make(configuration: .development, processingStageDelayNanoseconds: 1)
        let model = PhaseOneViewModel(container: container)
        let session = try await saveAudioSession(in: container)

        await model.reloadForTesting()
        model.startCuratedNoteProcessing(for: session)
        try await waitForNote(sessionID: session.id, in: model)

        let savedSession = try await container.sessions.fetch(id: session.id)
        let note = try XCTUnwrap(model.note(for: session.id))
        XCTAssertEqual(savedSession?.title, "Launch Checklist Field Memo")
        XCTAssertEqual(note.suggestedTitle, "Launch Checklist Field Memo")
        XCTAssertEqual(note.confirmedTitle, "Launch Checklist Field Memo")

        await model.undoGeneratedTitle(for: try XCTUnwrap(savedSession), note: note)
        let undoneSession = try await container.sessions.fetch(id: session.id)
        let undoneNote = try await container.curatedNotes.fetchNote(for: session.id)
        XCTAssertEqual(undoneSession?.title, "Audio Recording")
        XCTAssertNil(undoneNote?.confirmedTitle)
    }

    func testCuratedNoteEditsPersistActionCompletionAndMultilineKeyPoints() async throws {
        let container = DependencyContainer.make(configuration: .development, processingStageDelayNanoseconds: 1)
        let model = PhaseOneViewModel(container: container)
        let session = try await saveAudioSession(in: container)

        await model.reloadForTesting()
        model.startCuratedNoteProcessing(for: session)
        try await waitForNote(sessionID: session.id, in: model)

        let note = try XCTUnwrap(model.note(for: session.id))
        var actions = note.structuredActionItems
        actions[0].isCompleted = true

        await model.saveCuratedNoteEdits(
            note,
            summary: "Updated summary",
            keyPoints: ["First line\nsecond line", "Another point"],
            actionItems: actions,
            userNotes: "Reviewer note"
        )

        let fetched = try await container.curatedNotes.fetchNote(for: session.id)
        let persisted = try XCTUnwrap(fetched)
        XCTAssertEqual(persisted.summary, "Updated summary")
        XCTAssertEqual(persisted.keyPoints.first, "First line\nsecond line")
        XCTAssertTrue(persisted.structuredActionItems[0].isCompleted)
        XCTAssertEqual(persisted.userNotes, "Reviewer note")
        XCTAssertTrue(persisted.documentBlocks.contains { $0.origin == .userAuthored && $0.text == "Reviewer note" })
        XCTAssertTrue(persisted.documentBlocks.contains { $0.type == .checklist && $0.isChecked == true })
    }

    func testCuratedNotePersistenceAndMigrationCompatibility() async throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent("cura-transcription-\(UUID().uuidString)")
        let container = DependencyContainer.makeLocalJSON(
            configuration: .development,
            rootDirectory: root,
            audioRecorder: MockAudioRecordingProvider(),
            audioPlayback: MockAudioPlaybackProvider(),
            transcription: MockTranscriptionProvider(stageDelayNanoseconds: 1)
        )
        let model = PhaseOneViewModel(container: container)
        let session = try await saveAudioSession(in: container)

        await model.reloadForTesting()
        model.startCuratedNoteProcessing(for: session)
        try await waitForNote(sessionID: session.id, in: model)

        let reloaded = DependencyContainer.makeLocalJSON(
            configuration: .development,
            rootDirectory: root,
            audioRecorder: MockAudioRecordingProvider(),
            audioPlayback: MockAudioPlaybackProvider()
        )
        let reloadedModel = PhaseOneViewModel(container: reloaded)
        await reloadedModel.reloadForTesting()
        XCTAssertEqual(reloadedModel.note(for: session.id)?.generationStatus, .completed)
        XCTAssertFalse(reloadedModel.note(for: session.id)?.transcript.isEmpty ?? false)

        let legacyJSON = """
        {
          "id": "\(UUID().uuidString)",
          "sessionID": "\(UUID().uuidString)",
          "schemaVersion": "1.0",
          "promptVersion": "mock-phase-1",
          "title": "Legacy",
          "smartSummary": "Old summary",
          "createdAt": "2026-07-20T00:00:00Z"
        }
        """
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let legacyNote = try decoder.decode(CuratedNote.self, from: Data(legacyJSON.utf8))
        XCTAssertEqual(legacyNote.summary, "Old summary")
        XCTAssertEqual(legacyNote.transcript, "")
        XCTAssertEqual(legacyNote.generationStatus, .completed)
        XCTAssertTrue(legacyNote.documentBlocks.isEmpty)
    }

    func testActionItemEvidenceBehavior() async throws {
        let result = try await MockTranscriptionProvider(stageDelayNanoseconds: 1).transcribe(
            session: CaptureSession(title: "Audio Recording", mode: .create),
            source: CaptureSource(sessionID: UUID(), sourceType: .liveAudio),
            progress: { _ in }
        )

        XCTAssertTrue(result.actionItems.allSatisfy { $0.supportingExcerpt?.isEmpty == false || $0.timestamp != nil })
        XCTAssertTrue(result.actionItems.contains { $0.evidenceState == .stronglySupported })
    }

    private func saveAudioSession(in container: DependencyContainer) async throws -> CaptureSession {
        let session = CaptureSession(title: "Audio Recording", mode: .create, status: .ready)
        let audioURL = try await container.mediaStorage.audioRecordingURL(sessionID: session.id, sourceID: UUID())
        try Data("audio".utf8).write(to: audioURL)
        let source = CaptureSource(
            sessionID: session.id,
            sourceType: .liveAudio,
            originalFilename: "Audio Recording.m4a",
            mimeType: "audio/mp4",
            duration: 14,
            sourceURL: audioURL,
            transcriptOrigin: .speechToText
        )
        try await container.sessions.save(session)
        try await container.sources.save(source)
        return session
    }

    private func seed(session: CaptureSession, source: CaptureSource, into container: DependencyContainer) async throws {
        try await container.sessions.save(session)
        try await container.sources.save(source)
    }

    private func waitForNote(sessionID: UUID, in model: PhaseOneViewModel) async throws {
        for _ in 0..<60 {
            if model.note(for: sessionID) != nil {
                return
            }
            try await Task.sleep(nanoseconds: 50_000_000)
        }
        XCTFail("Timed out waiting for Curated Note")
    }
}
