import XCTest
@testable import CuraCore

@MainActor
final class PhaseOneViewModelTests: XCTestCase {
    func testImportCreatesDraftSessionWithCopiedVideo() async throws {
        let model = PhaseOneViewModel(container: .test, arguments: [])
        await model.loadIfNeeded()

        await model.importVideoForTesting(try makeVideoFile())

        XCTAssertEqual(model.draftSession?.status, .draft)
        XCTAssertEqual(model.sessions.first?.title, "sample")
    }

    func testFavoriteTogglingPersistsOnSession() async throws {
        let model = PhaseOneViewModel(container: .test, arguments: [])
        await model.loadIfNeeded()
        await model.importVideoForTesting(try makeVideoFile())
        await model.startProcessing()

        let session = try XCTUnwrap(model.selectedSession)
        await model.toggleFavorite(session)

        XCTAssertTrue(model.selectedSession?.isFavorite == true)
        XCTAssertTrue(model.sessions.first?.isFavorite == true)
    }

    func testFolderAssignmentPersistsThroughProcessing() async throws {
        let model = PhaseOneViewModel(container: .test, arguments: [])
        await model.loadIfNeeded()
        model.newFolderName = "Creator Clips"
        await model.addFolder()
        await model.importVideoForTesting(try makeVideoFile())

        model.setupFolderID = model.folders.first?.id
        await model.startProcessing()

        XCTAssertEqual(model.selectedSession?.folderID, model.folders.first?.id)
    }

    func testFolderCreationRefreshesAndCanAssignExistingSession() async throws {
        let container = DependencyContainer.test
        let session = CaptureSession(title: "Audio Recording", mode: .learn, status: .ready)
        try await container.sessions.save(session)
        let model = PhaseOneViewModel(container: container, arguments: [])
        await model.loadIfNeeded()

        model.newFolderName = "Field Notes"
        let createdFolder = await model.addFolder()
        let folder = try XCTUnwrap(createdFolder)
        await model.saveSessionMetadata(
            session,
            title: session.title,
            mode: session.mode,
            folderID: folder.id,
            processingMode: session.processingMode
        )

        XCTAssertEqual(model.folders.first?.name, "Field Notes")
        XCTAssertEqual(model.selectedSession?.folderID, folder.id)

        let relaunched = PhaseOneViewModel(container: container, arguments: [])
        await relaunched.loadIfNeeded()
        XCTAssertEqual(relaunched.sessions.first?.folderID, folder.id)
    }

    func testFoldersPersistAcrossOrdinaryRelaunch() async throws {
        let root = FileManager.default.temporaryDirectory
            .appendingPathComponent("cura-folder-persistence")
            .appendingPathComponent(UUID().uuidString)
        let container = DependencyContainer.makeLocalJSON(
            configuration: .development,
            rootDirectory: root,
            audioRecorder: MockAudioRecordingProvider(),
            audioPlayback: MockAudioPlaybackProvider()
        )
        let model = PhaseOneViewModel(container: container, arguments: [])
        await model.loadIfNeeded()
        model.newFolderName = "Site Notes"
        let createdFolder = await model.addFolder()
        let folder = try XCTUnwrap(createdFolder)

        let relaunched = PhaseOneViewModel(container: container, arguments: [])
        await relaunched.loadIfNeeded()

        XCTAssertEqual(relaunched.folders.first?.id, folder.id)
        XCTAssertEqual(relaunched.folders.first?.name, "Site Notes")
        try await container.libraryMaintenance?.reset()
    }

    func testProcessingSuccessCreatesCuratedNoteAndCreatorPackOutput() async throws {
        let model = PhaseOneViewModel(container: .test, arguments: [])
        await model.loadIfNeeded()
        await model.importVideoForTesting(try makeVideoFile())
        await model.startProcessing()

        let session = try XCTUnwrap(model.selectedSession)
        XCTAssertEqual(session.status, .completed)
        XCTAssertNotNil(model.note(for: session.id))
        XCTAssertEqual(model.instagramCaption(for: session.id)?.packKey, "creator")
        XCTAssertEqual(model.completedStages, Set(PhaseOneProcessingStage.allCases))
    }

    func testProcessingFailureMarksSessionFailedAndKeepsVideoSession() async throws {
        let container = DependencyContainer.make(
            configuration: .development,
            processingStageDelayNanoseconds: 0,
            processingShouldFail: true
        )
        let model = PhaseOneViewModel(container: container, arguments: [])
        await model.loadIfNeeded()
        await model.importVideoForTesting(try makeVideoFile())
        await model.startProcessing()

        XCTAssertEqual(model.selectedSession?.status, .failed)
        XCTAssertEqual(model.sessions.first?.status, .failed)
        XCTAssertTrue(model.errorMessage.contains("Mock processing failed"))
    }

    func testQuickSendFallbackSelectsShareSheet() async throws {
        let model = PhaseOneViewModel(container: .test, arguments: [])

        await model.copyAndOpenInstagram("Caption")

        XCTAssertEqual(model.shareItem?.text, "Caption")
    }

    func testProcessingStageLabelsAreSourceAware() {
        XCTAssertEqual(PhaseOneProcessingStage.readingVideo.title(sourceType: .liveAudio), "Reading Audio")
        XCTAssertEqual(PhaseOneProcessingStage.readingVideo.title(sourceType: .uploadedAudio), "Reading Audio")
        XCTAssertEqual(PhaseOneProcessingStage.readingVideo.title(sourceType: .uploadedVideo), "Reading Video")
    }

    func testReadyAudioSessionDoesNotShowProcessingStages() async throws {
        let container = DependencyContainer.test
        let session = CaptureSession(title: "Audio Recording", mode: .learn, status: .ready)
        let source = CaptureSource(
            sessionID: session.id,
            sourceType: .liveAudio,
            originalFilename: "recording.m4a",
            mimeType: "audio/mp4",
            duration: 4
        )
        try await container.sessions.save(session)
        try await container.sources.save(source)

        let model = PhaseOneViewModel(container: container, arguments: [])
        await model.loadIfNeeded()

        XCTAssertFalse(model.shouldShowProcessing(for: session))
        XCTAssertEqual(model.primarySourceType(for: session.id), .liveAudio)
    }

    private func makeVideoFile() throws -> URL {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathComponent("sample.mov")
        try FileManager.default.createDirectory(
            at: url.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try Data("mock video".utf8).write(to: url)
        return url
    }
}
