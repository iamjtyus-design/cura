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
