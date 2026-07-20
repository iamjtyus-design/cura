import Foundation
import CuraCore

enum SmokeTestFailure: Error, CustomStringConvertible {
    case failed(String)

    var description: String {
        switch self {
        case .failed(let message):
            return message
        }
    }
}

func expect(_ condition: @autoclosure () -> Bool, _ message: String) throws {
    if !condition() {
        throw SmokeTestFailure.failed(message)
    }
}

@main
struct CuraSmokeTests {
    static func main() async throws {
        let session = CaptureSession(title: "Phase 0", mode: .create)
        try expect(session.status == .draft, "CaptureSession should default to draft.")
        try expect(session.processingMode == .smart, "CaptureSession should default to Smart Mode.")

        let container = DependencyContainer.test
        try await container.sessions.save(session)
        let fetched = try await container.sessions.fetch(id: session.id)
        try expect(fetched?.id == session.id, "In-memory session repository should fetch saved sessions.")

        let result = try await container.processing.process(session: session, sources: [])
        try expect(result.job.stage == .completed, "Mock processing should complete.")
        try expect(result.note.sessionID == session.id, "Mock Curated Note should belong to the session.")

        let output = GeneratedOutput(
            sessionID: session.id,
            curatedNoteID: result.note.id,
            outputType: .creatorPack,
            mode: .create,
            packKey: "creator",
            content: "Copied. Open Instagram when ready."
        )
        let data = try await container.export.render(output: output, format: .plainText)
        try expect(String(decoding: data, as: UTF8.self) == output.content, "Mock export should return output content.")

        print("CURA Phase 0 smoke tests passed.")
    }
}
