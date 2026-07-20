import XCTest
@testable import CuraCore

final class DomainModelTests: XCTestCase {
    func testCaptureSessionDefaultsArePhaseZeroSafe() {
        let session = CaptureSession(title: "Interview", mode: .create)

        XCTAssertEqual(session.status, .draft)
        XCTAssertEqual(session.processingMode, .smart)
        XCTAssertFalse(session.isFavorite)
        XCTAssertEqual(session.outputLanguage, "en")
    }

    func testCuratedNoteKeepsVersionAndEvidenceFields() {
        let sessionID = UUID()
        let sourceID = UUID()
        let evidence = EvidenceReference(sourceID: sourceID, startTime: 1, endTime: 2, confidence: 0.9)
        let note = CuratedNote(
            sessionID: sessionID,
            title: "Walkthrough",
            smartSummary: "Source-backed summary",
            evidenceReferences: [evidence]
        )

        XCTAssertEqual(note.schemaVersion, "1.0")
        XCTAssertEqual(note.promptVersion, "1.0")
        XCTAssertEqual(note.evidenceReferences.first?.sourceID, sourceID)
    }
}
