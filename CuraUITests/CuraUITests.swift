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

        recordAndSaveAudio(in: app)

        let titleField = app.textFields["topSessionTitleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 5))
        titleField.replaceText(with: "Field Memo")
        app.swipeUp()
        XCTAssertTrue(app.buttons["Save Session Details"].waitForExistence(timeout: 5))
        app.buttons["Save Session Details"].tap()
        app.swipeDown()
        XCTAssertTrue(app.buttons["Create Curated Note"].waitForExistence(timeout: 5))
        app.buttons["Create Curated Note"].tap()
        XCTAssertTrue(app.textFields["suggestedTitleField"].waitForExistence(timeout: 8))
        app.textFields["suggestedTitleField"].replaceText(with: "Edited Launch Memo")
        app.buttons["Accept Title"].tap()
        XCTAssertTrue(app.buttons["Transcript"].waitForExistence(timeout: 5))
        app.buttons["Transcript"].tap()
        XCTAssertTrue(app.staticTexts["transcriptText"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "launch checklist")).firstMatch.exists)
        app.buttons["Recording"].tap()
        XCTAssertTrue(app.buttons["Play Recording"].exists)
        app.buttons["Play Recording"].tap()
        let playbackProgress = app.sliders["playbackProgress"]
        XCTAssertTrue(playbackProgress.waitForValueNotBeginning(with: "00:00 of", timeout: 4))
        app.swipeUp()
        app.buttons["Back to Sessions"].tap()
        XCTAssertTrue(app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Edited Launch Memo")).firstMatch.waitForExistence(timeout: 5))

        app.terminate()

        let relaunched = XCUIApplication()
        relaunched.launchArguments = ["-ui-testing"]
        relaunched.launch()
        XCTAssertTrue(relaunched.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Edited Launch Memo")).firstMatch.waitForExistence(timeout: 5))
        relaunched.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Edited Launch Memo")).firstMatch.tap()
        XCTAssertTrue(relaunched.buttons["Transcript"].waitForExistence(timeout: 5))
        relaunched.buttons["Transcript"].tap()
        XCTAssertTrue(relaunched.staticTexts["transcriptText"].waitForExistence(timeout: 5))
    }

    func testPhaseTwoBMockTranscriptionFailureAndRetry() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-reset-phase1-store", "-mock-transcription-failure"]
        app.launch()

        recordAndSaveAudio(in: app)
        XCTAssertTrue(app.buttons["Create Curated Note"].waitForExistence(timeout: 5))
        app.buttons["Create Curated Note"].tap()
        XCTAssertTrue(app.buttons["OK"].waitForExistence(timeout: 8))
        app.buttons["OK"].tap()
        XCTAssertTrue(app.buttons["Retry Create Curated Note"].waitForExistence(timeout: 5))

        app.buttons["Back to Sessions"].tap()
        app.terminate()

        let retryApp = XCUIApplication()
        retryApp.launchArguments = ["-ui-testing"]
        retryApp.launch()
        XCTAssertTrue(retryApp.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Audio Recording")).firstMatch.waitForExistence(timeout: 5))
        retryApp.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Audio Recording")).firstMatch.tap()
        XCTAssertTrue(retryApp.buttons["Retry Create Curated Note"].waitForExistence(timeout: 5))
        retryApp.buttons["Retry Create Curated Note"].tap()
        XCTAssertTrue(retryApp.textFields["suggestedTitleField"].waitForExistence(timeout: 8))
        retryApp.buttons["Transcript"].tap()
        XCTAssertTrue(retryApp.staticTexts["transcriptText"].waitForExistence(timeout: 5))
    }
}

@MainActor
private func recordAndSaveAudio(in app: XCUIApplication) {
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
}

private extension XCUIElement {
    func replaceText(with text: String) {
        tap()
        if let current = value as? String, !current.isEmpty {
            typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: max(current.count, 100)))
        }
        typeText(text)
    }

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
