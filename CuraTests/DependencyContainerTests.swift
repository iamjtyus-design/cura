import XCTest
@testable import CuraCore

final class DependencyContainerTests: XCTestCase {
    func testTestContainerUsesMockProvidersAndInMemoryRepositories() async throws {
        let container = DependencyContainer.test
        let session = CaptureSession(title: "Phase 0", mode: .work)

        try await container.sessions.save(session)
        let fetched = try await container.sessions.fetch(id: session.id)
        let result = try await container.processing.process(session: session, sources: [])

        XCTAssertEqual(fetched?.id, session.id)
        XCTAssertEqual(result.job.stage, .completed)
        XCTAssertEqual(result.note.sessionID, session.id)
    }

    func testMockExportDoesNotCallExternalServices() async throws {
        let sessionID = UUID()
        let noteID = UUID()
        let output = GeneratedOutput(
            sessionID: sessionID,
            curatedNoteID: noteID,
            outputType: .creatorPack,
            mode: .create,
            packKey: "creator",
            content: "Copied. Open Instagram when ready."
        )

        let data = try await DependencyContainer.test.export.render(output: output, format: .plainText)

        XCTAssertEqual(String(decoding: data, as: UTF8.self), output.content)
    }

    func testJSONLocalLibraryStorePersistsPhaseOneResults() async throws {
        let root = FileManager.default.temporaryDirectory
            .appendingPathComponent("cura-store-tests")
            .appendingPathComponent(UUID().uuidString)
        let store = JSONLocalLibraryStore(rootDirectory: root)
        let session = CaptureSession(title: "Imported Video", mode: .create, status: .completed, isFavorite: true)
        let note = CuratedNote(sessionID: session.id, title: session.title, smartSummary: "Mock note")
        let output = GeneratedOutput(
            sessionID: session.id,
            curatedNoteID: note.id,
            outputType: .creatorPack,
            mode: .create,
            packKey: "creator",
            content: "Mock caption"
        )
        let pack = OutputPack(sessionID: session.id, curatedNoteID: note.id, packKey: "creator", mode: .create, outputs: [output])
        let snapshot = CaptureLibrarySnapshot(
            sessions: [session],
            favorites: [Favorite(sessionID: session.id)],
            curatedNotes: [note],
            outputPacks: [pack],
            generatedOutputs: [output]
        )

        try await store.save(snapshot)
        let reloaded = try await JSONLocalLibraryStore(rootDirectory: root).load()

        XCTAssertEqual(reloaded.sessions.first?.title, "Imported Video")
        XCTAssertEqual(reloaded.curatedNotes.first?.smartSummary, "Mock note")
        XCTAssertEqual(reloaded.generatedOutputs.first?.content, "Mock caption")
        XCTAssertEqual(reloaded.favorites.first?.sessionID, session.id)

        try await store.reset()
    }
}
