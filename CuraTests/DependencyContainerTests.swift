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
}
