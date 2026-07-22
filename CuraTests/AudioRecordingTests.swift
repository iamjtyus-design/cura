import XCTest
@testable import CuraCore

@MainActor
final class AudioRecordingTests: XCTestCase {
    func testRecordingStateTransitions() {
        var machine = AudioRecordingStateMachine()

        XCTAssertTrue(machine.transition(to: .requestingPermission))
        XCTAssertTrue(machine.transition(to: .ready))
        XCTAssertTrue(machine.transition(to: .recording))
        XCTAssertTrue(machine.transition(to: .paused))
        XCTAssertTrue(machine.transition(to: .recording))
        XCTAssertTrue(machine.transition(to: .stopping))
        XCTAssertTrue(machine.transition(to: .completed))
    }

    func testPauseAndResume() async {
        let model = AudioRecordingViewModel(container: .test)

        await model.acceptConsentAndPrepare()
        await model.startRecording()
        await model.pauseRecording()
        XCTAssertEqual(model.state, .paused)

        await model.resumeRecording()
        XCTAssertEqual(model.state, .recording)
    }

    func testElapsedRecordingTimeAdvancesWhileRecording() async throws {
        let model = AudioRecordingViewModel(container: .test)

        await model.acceptConsentAndPrepare()
        await model.startRecording()
        try await Task.sleep(nanoseconds: 350_000_000)

        XCTAssertGreaterThan(model.duration, 0)
        await model.cancelRecording()
    }

    func testPauseResumePreservesAccumulatedDuration() async throws {
        let model = AudioRecordingViewModel(container: .test)

        await model.acceptConsentAndPrepare()
        await model.startRecording()
        try await Task.sleep(nanoseconds: 250_000_000)
        await model.pauseRecording()
        let pausedDuration = model.duration
        try await Task.sleep(nanoseconds: 250_000_000)

        XCTAssertEqual(model.duration, pausedDuration, accuracy: 0.15)

        await model.resumeRecording()
        try await Task.sleep(nanoseconds: 250_000_000)

        XCTAssertGreaterThan(model.duration, pausedDuration)
        await model.cancelRecording()
    }

    func testStopAndSaveCreatesSessionAndSource() async throws {
        let container = DependencyContainer.test
        let model = AudioRecordingViewModel(container: container)

        await model.acceptConsentAndPrepare()
        await model.startRecording()
        await model.addMarker()
        await model.stopAndSave()

        let session = try XCTUnwrap(model.savedSession)
        let sources = try await container.sources.fetchSources(for: session.id)
        XCTAssertEqual(model.state, .completed)
        XCTAssertEqual(sources.first?.sourceType, .liveAudio)
        XCTAssertEqual(sources.first?.mimeType, "audio/mp4")
        XCTAssertEqual(session.mode, .create)
    }

    func testFreshRecordingPersistsDurablePlayableSourceURL() async throws {
        let playback = TrackingAudioPlaybackProvider()
        let container = DependencyContainer.make(
            configuration: .development,
            audioRecorder: MockAudioRecordingProvider(),
            audioPlayback: playback
        )
        let model = AudioRecordingViewModel(container: container)

        await model.acceptConsentAndPrepare()
        await model.startRecording()
        await model.stopAndSave()

        let source = try XCTUnwrap(model.savedSource)
        let url = try XCTUnwrap(source.sourceURL)
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
        XCTAssertTrue(url.path.contains("/Media/\(source.sessionID.uuidString)/"))
        let loadedURL = await playback.lastLoadedURL()
        XCTAssertEqual(loadedURL, url)
        XCTAssertEqual(model.playbackDuration, 3, accuracy: 0.05)
    }

    func testFreshPlaybackSurvivesSessionCloseAndReopen() async throws {
        let playback = TrackingAudioPlaybackProvider()
        let container = DependencyContainer.make(
            configuration: .development,
            audioRecorder: MockAudioRecordingProvider(),
            audioPlayback: playback
        )
        let model = AudioRecordingViewModel(container: container)

        await model.acceptConsentAndPrepare()
        await model.startRecording()
        await model.stopAndSave()

        let source = try XCTUnwrap(model.savedSource)
        await model.prepareForNewCapturePresentation()
        await model.loadPlayback(url: try XCTUnwrap(source.sourceURL))
        await model.play(url: source.sourceURL)

        XCTAssertTrue(model.isPlaybackPlaying)
        let loadedURL = await playback.lastLoadedURL()
        XCTAssertEqual(loadedURL, source.sourceURL)
    }

    func testFreshPlaybackSurvivesOrdinaryRelaunch() async throws {
        let root = FileManager.default.temporaryDirectory
            .appendingPathComponent("cura-audio-relaunch-playback")
            .appendingPathComponent(UUID().uuidString)
        let firstPlayback = TrackingAudioPlaybackProvider()
        let container = DependencyContainer.makeLocalJSON(
            configuration: .development,
            rootDirectory: root,
            audioRecorder: MockAudioRecordingProvider(),
            audioPlayback: firstPlayback
        )
        let model = AudioRecordingViewModel(container: container)
        await model.acceptConsentAndPrepare()
        await model.startRecording()
        await model.stopAndSave()
        let session = try XCTUnwrap(model.savedSession)

        let secondPlayback = TrackingAudioPlaybackProvider()
        let relaunched = DependencyContainer.makeLocalJSON(
            configuration: .development,
            rootDirectory: root,
            audioRecorder: MockAudioRecordingProvider(),
            audioPlayback: secondPlayback
        )
        let library = PhaseOneViewModel(container: relaunched, arguments: [])
        let playbackModel = AudioRecordingViewModel(container: relaunched)
        await library.loadIfNeeded()
        let source = try XCTUnwrap(library.audioSource(for: session.id))

        await playbackModel.loadPlayback(url: try XCTUnwrap(source.sourceURL))
        await playbackModel.play(url: source.sourceURL)

        XCTAssertTrue(playbackModel.isPlaybackPlaying)
        let loadedURL = await secondPlayback.lastLoadedURL()
        XCTAssertEqual(loadedURL, source.sourceURL)
        try await relaunched.libraryMaintenance?.reset()
    }

    func testMultipleFreshRecordingsRemainIndependentlyPlayable() async throws {
        let container = DependencyContainer.make(
            configuration: .development,
            audioRecorder: MockAudioRecordingProvider(),
            audioPlayback: TrackingAudioPlaybackProvider()
        )
        let first = AudioRecordingViewModel(container: container)
        await first.acceptConsentAndPrepare()
        await first.startRecording()
        await first.stopAndSave()

        let second = AudioRecordingViewModel(container: container)
        await second.acceptConsentAndPrepare()
        await second.startRecording()
        await second.stopAndSave()

        let firstURL = try XCTUnwrap(first.savedSource?.sourceURL)
        let secondURL = try XCTUnwrap(second.savedSource?.sourceURL)
        XCTAssertNotEqual(firstURL, secondURL)
        XCTAssertTrue(FileManager.default.fileExists(atPath: firstURL.path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: secondURL.path))
    }

    func testNewRecordingDoesNotAttemptPlaybackWithoutSavedFile() async {
        let model = AudioRecordingViewModel(container: .test)

        model.prepareForNewCapture()
        await model.recordTapped()

        XCTAssertTrue(model.errorMessage.isEmpty)
        XCTAssertTrue(model.playbackUnavailableMessage.isEmpty)
        XCTAssertEqual(model.playbackDuration, 0)
        XCTAssertEqual(model.playbackPosition, 0)
    }

    func testMissingPlaybackFileUsesInlineUnavailableState() async {
        let model = AudioRecordingViewModel(container: .test)
        let missingURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("m4a")

        await model.loadPlayback(url: missingURL)

        XCTAssertTrue(model.errorMessage.isEmpty)
        XCTAssertTrue(model.playbackUnavailableMessage.contains("no longer available"))
        XCTAssertEqual(model.playbackDuration, 0)
    }

    func testMissingLegacyFileRemainsLocalizedAndPreservesNote() async throws {
        let container = DependencyContainer.test
        let session = CaptureSession(title: "Legacy Recording", mode: .create, status: .completed)
        let missingURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("m4a")
        let source = CaptureSource(sessionID: session.id, sourceType: .liveAudio, sourceURL: missingURL)
        let note = CuratedNote(sessionID: session.id, title: "Legacy Note", smartSummary: "Keep me")
        try await container.sessions.save(session)
        try await container.sources.save(source)
        try await container.curatedNotes.save(note)

        let playback = AudioRecordingViewModel(container: container)
        await playback.loadPlayback(url: missingURL)

        XCTAssertTrue(playback.playbackUnavailableMessage.contains("no longer available"))
        let sources = try await container.sources.fetchSources(for: session.id)
        let savedNote = try await container.curatedNotes.fetchNote(for: session.id)
        XCTAssertEqual(sources.count, 1)
        XCTAssertEqual(savedNote?.smartSummary, "Keep me")
    }

    func testConsentNoticeFirstDisplayAndSubsequentSuppression() async {
        let container = DependencyContainer.test
        let model = AudioRecordingViewModel(container: container)

        await model.recordTapped()
        XCTAssertTrue(model.showConsentNotice)

        await model.acceptConsentAndPrepare()
        XCTAssertFalse(model.showConsentNotice)
        XCTAssertEqual(model.state, .ready)

        model.prepareForNewCapture()
        await model.recordTapped()

        XCTAssertFalse(model.showConsentNotice)
        XCTAssertEqual(model.state, .ready)
    }

    func testConsentAcknowledgementSurvivesRelaunchStyleModelRecreation() async {
        let container = DependencyContainer.test
        let model = AudioRecordingViewModel(container: container)

        await model.recordTapped()
        await model.acceptConsentAndPrepare()

        let relaunched = AudioRecordingViewModel(container: container)
        await relaunched.prepareForNewCapturePresentation()

        XCTAssertFalse(relaunched.showConsentNotice)
        XCTAssertEqual(relaunched.state, .ready)
    }

    func testConsentResetPathShowsNoticeAgain() async {
        let model = AudioRecordingViewModel(container: .test)

        await model.recordTapped()
        await model.acceptConsentAndPrepare()
        await model.resetAudioConsentForTesting()
        model.prepareForNewCapture()
        await model.recordTapped()

        XCTAssertTrue(model.showConsentNotice)
    }

    func testPermissionDenialFailsClearly() async {
        let container = DependencyContainer.make(
            configuration: .development,
            audioRecorder: MockAudioRecordingProvider(permission: .denied),
            audioPlayback: MockAudioPlaybackProvider()
        )
        let model = AudioRecordingViewModel(container: container)

        await model.acceptConsentAndPrepare()

        XCTAssertEqual(model.state, .failed)
        XCTAssertTrue(model.errorMessage.contains("denied"))
    }

    func testInterruptionPersistsRecoveryMetadata() async throws {
        let container = DependencyContainer.test
        let model = AudioRecordingViewModel(container: container)

        await model.acceptConsentAndPrepare()
        await model.startRecording()
        await model.addMarker()
        await model.handleInterruption(.headphonesDisconnected)

        let fetchedRecovery = try await container.audioRecovery.fetch()
        let recovery = try XCTUnwrap(fetchedRecovery)
        XCTAssertEqual(model.state, .interrupted)
        XCTAssertEqual(recovery.interruptionReason, .headphonesDisconnected)
        XCTAssertEqual(recovery.markers.count, 1)
    }

    func testRecoveryMetadataLoadsAfterRelaunch() async throws {
        let root = FileManager.default.temporaryDirectory
            .appendingPathComponent("cura-audio-recovery")
            .appendingPathComponent(UUID().uuidString)
        let container = DependencyContainer.makeLocalJSON(
            configuration: .development,
            rootDirectory: root,
            audioRecorder: MockAudioRecordingProvider(),
            audioPlayback: MockAudioPlaybackProvider()
        )
        let model = AudioRecordingViewModel(container: container)
        await model.acceptConsentAndPrepare()
        await model.startRecording()
        await model.handleInterruption(.appBackgrounded)

        let relaunched = AudioRecordingViewModel(container: container)
        await relaunched.load()

        XCTAssertEqual(relaunched.state, .interrupted)
        XCTAssertEqual(relaunched.recoveredMetadata?.interruptionReason, .appBackgrounded)
        try await container.libraryMaintenance?.reset()
    }

    func testDeletionRemovesAudioSourceAndSession() async throws {
        let container = DependencyContainer.test
        let audioModel = AudioRecordingViewModel(container: container)
        let libraryModel = PhaseOneViewModel(container: container, arguments: [])

        await audioModel.acceptConsentAndPrepare()
        await audioModel.startRecording()
        await audioModel.stopAndSave()
        await libraryModel.loadIfNeeded()

        let session = try XCTUnwrap(audioModel.savedSession)
        await libraryModel.deleteSession(session)

        let deletedSession = try await container.sessions.fetch(id: session.id)
        let deletedSources = try await container.sources.fetchSources(for: session.id)
        XCTAssertNil(deletedSession)
        XCTAssertTrue(deletedSources.isEmpty)
    }

    func testAudioSessionPersistsAfterRelaunch() async throws {
        let root = FileManager.default.temporaryDirectory
            .appendingPathComponent("cura-audio-persistence")
            .appendingPathComponent(UUID().uuidString)
        let container = DependencyContainer.makeLocalJSON(
            configuration: .development,
            rootDirectory: root,
            audioRecorder: MockAudioRecordingProvider(),
            audioPlayback: MockAudioPlaybackProvider()
        )
        let model = AudioRecordingViewModel(container: container)
        await model.acceptConsentAndPrepare()
        await model.startRecording()
        await model.stopAndSave()

        let libraryModel = PhaseOneViewModel(container: container, arguments: [])
        await libraryModel.loadIfNeeded()

        let session = try XCTUnwrap(model.savedSession)
        XCTAssertEqual(libraryModel.sessions.first?.id, session.id)
        XCTAssertEqual(libraryModel.audioSource(for: session.id)?.sourceType, .liveAudio)
        try await container.libraryMaintenance?.reset()
    }

    func testPlaybackProgressAdvancesWhilePlaying() async throws {
        let container = DependencyContainer.test
        let model = AudioRecordingViewModel(container: container)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("m4a")
        try Data("mock audio".utf8).write(to: url)

        await model.loadPlayback(url: url)
        await model.play()
        try await Task.sleep(nanoseconds: 350_000_000)

        XCTAssertTrue(model.isPlaybackPlaying)
        XCTAssertGreaterThan(model.playbackPosition, 0)
    }

    func testPlaybackCanStartFromSourceURLAfterSeek() async throws {
        let container = DependencyContainer.test
        let model = AudioRecordingViewModel(container: container)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("m4a")
        try Data("mock audio".utf8).write(to: url)

        await model.loadPlayback(url: url)
        await model.seek(to: 1)
        await model.play(url: url)
        try await Task.sleep(nanoseconds: 250_000_000)

        XCTAssertTrue(model.isPlaybackPlaying)
        XCTAssertGreaterThan(model.playbackPosition, 1)
    }

    func testSeekUpdatesPlaybackPosition() async throws {
        let container = DependencyContainer.test
        let model = AudioRecordingViewModel(container: container)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("m4a")
        try Data("mock audio".utf8).write(to: url)

        await model.loadPlayback(url: url)
        await model.seek(to: 1.5)

        XCTAssertEqual(model.playbackPosition, 1.5, accuracy: 0.05)
    }

    func testPlaybackCompletionResetsPositionAndState() async throws {
        let container = DependencyContainer.make(
            configuration: .development,
            audioRecorder: MockAudioRecordingProvider(),
            audioPlayback: MockAudioPlaybackProvider(duration: 0.25)
        )
        let model = AudioRecordingViewModel(container: container)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("m4a")
        try Data("mock audio".utf8).write(to: url)

        await model.loadPlayback(url: url)
        await model.play()
        try await Task.sleep(nanoseconds: 550_000_000)

        XCTAssertFalse(model.isPlaybackPlaying)
        XCTAssertEqual(model.playbackPosition, 0, accuracy: 0.05)
    }
}

private actor TrackingAudioPlaybackProvider: AudioPlaybackProviding {
    private(set) var loadedURLs: [URL] = []
    private var provider = MockAudioPlaybackProvider(duration: 3)

    func load(url: URL) async throws -> TimeInterval {
        loadedURLs.append(url)
        return try await provider.load(url: url)
    }

    func play() async throws {
        try await provider.play()
    }

    func pause() async {
        await provider.pause()
    }

    func seek(to time: TimeInterval) async {
        await provider.seek(to: time)
    }

    func currentTime() async -> TimeInterval {
        await provider.currentTime()
    }

    func isPlaying() async -> Bool {
        await provider.isPlaying()
    }

    func lastLoadedURL() -> URL? {
        loadedURLs.last
    }
}
