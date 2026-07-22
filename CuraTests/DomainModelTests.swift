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
        let block = CuratedNoteBlock(type: .checklist, origin: .generated, text: "Follow up", isChecked: false)
        let note = CuratedNote(
            sessionID: sessionID,
            title: "Walkthrough",
            smartSummary: "Source-backed summary",
            evidenceReferences: [evidence],
            documentBlocks: [block]
        )

        XCTAssertEqual(note.schemaVersion, "2.1")
        XCTAssertEqual(note.promptVersion, "1.0")
        XCTAssertEqual(note.evidenceReferences.first?.sourceID, sourceID)
        XCTAssertEqual(note.generationStatus, .completed)
        XCTAssertEqual(note.documentBlocks.first?.id, block.id)
        XCTAssertEqual(note.documentBlocks.first?.type, .checklist)
        XCTAssertEqual(note.documentBlocks.first?.origin, .generated)
    }
}
