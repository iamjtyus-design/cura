import XCTest

@MainActor
final class CuraUITests: XCTestCase {
    func testPhaseOneMockVideoImportFlowPersistsAfterRelaunch() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-reset-phase1-store"]
        app.launch()

        XCTAssertTrue(app.buttons["Import Video"].waitForExistence(timeout: 5))
        app.textFields["New folder name"].tap()
        app.textFields["New folder name"].typeText("Creator Clips")
        app.buttons["Add Folder"].tap()

        app.buttons["Import Video"].tap()
        XCTAssertTrue(app.textFields["Session title"].waitForExistence(timeout: 5))
        app.buttons["Start Mock Processing"].tap()

        XCTAssertTrue(app.staticTexts["Instagram Caption"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.staticTexts["Curated Note"].exists)
        app.buttons["Add Favorite"].tap()
        app.buttons["Copy"].tap()
        app.buttons["Back to Sessions"].tap()
        XCTAssertTrue(app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "cura-ui-test-video")).firstMatch.waitForExistence(timeout: 5))

        app.terminate()

        let relaunched = XCUIApplication()
        relaunched.launchArguments = ["-ui-testing"]
        relaunched.launch()
        XCTAssertTrue(relaunched.buttons.matching(NSPredicate(format: "label CONTAINS %@", "cura-ui-test-video")).firstMatch.waitForExistence(timeout: 5))
    }

    func testPhaseTwoAMockAudioRecordingFlowPersistsAfterRelaunch() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-reset-phase1-store"]
        app.launch()

        XCTAssertTrue(app.buttons["Record Audio"].waitForExistence(timeout: 5))
        app.buttons["Record Audio"].tap()
        XCTAssertTrue(app.buttons["Record Audio"].waitForExistence(timeout: 5))
        app.buttons["Record Audio"].tap()

        XCTAssertTrue(app.buttons["Continue"].waitForExistence(timeout: 5))
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.buttons["Start Recording"].waitForExistence(timeout: 5))
        app.buttons["Start Recording"].tap()
        XCTAssertTrue(app.buttons["Add Timestamp Marker"].waitForExistence(timeout: 5))
        let recordingDuration = app.staticTexts["recordingDuration"]
        XCTAssertTrue(recordingDuration.waitForLabelNotEqual(to: "00:00", timeout: 3))
        app.buttons["Add Timestamp Marker"].tap()
        app.buttons["Pause Recording"].tap()
        XCTAssertTrue(app.buttons["Resume Recording"].waitForExistence(timeout: 5))
        app.buttons["Resume Recording"].tap()
        app.buttons["Stop and Save"].tap()

        XCTAssertTrue(app.staticTexts["Audio Recording"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Play Recording"].exists)
        app.buttons["Play Recording"].tap()
        let playbackProgress = app.sliders["playbackProgress"]
        XCTAssertTrue(playbackProgress.waitForValueNotBeginning(with: "00:00 of", timeout: 4))
        app.buttons["Back to Sessions"].tap()
        XCTAssertTrue(app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Audio Recording")).firstMatch.waitForExistence(timeout: 5))

        app.terminate()

        let relaunched = XCUIApplication()
        relaunched.launchArguments = ["-ui-testing"]
        relaunched.launch()
        XCTAssertTrue(relaunched.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Audio Recording")).firstMatch.waitForExistence(timeout: 5))
    }
}

private extension XCUIElement {
    func waitForLabelNotEqual(to value: String, timeout: TimeInterval) -> Bool {
        waitForPredicate(NSPredicate(format: "label != %@", value), timeout: timeout)
    }

    func waitForLabelNotBeginning(with prefix: String, timeout: TimeInterval) -> Bool {
        waitForPredicate(NSPredicate(format: "NOT label BEGINSWITH %@", prefix), timeout: timeout)
    }

    func waitForValueNotBeginning(with prefix: String, timeout: TimeInterval) -> Bool {
        waitForPredicate(NSPredicate(format: "NOT value BEGINSWITH %@", prefix), timeout: timeout)
    }

    func waitForPredicate(_ predicate: NSPredicate, timeout: TimeInterval) -> Bool {
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        return XCTWaiter.wait(for: [expectation], timeout: timeout) == .completed
    }
}
