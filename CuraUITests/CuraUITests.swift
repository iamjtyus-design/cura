import XCTest

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
        app.buttons["Add Timestamp Marker"].tap()
        app.buttons["Pause Recording"].tap()
        XCTAssertTrue(app.buttons["Resume Recording"].waitForExistence(timeout: 5))
        app.buttons["Resume Recording"].tap()
        app.buttons["Stop and Save"].tap()

        XCTAssertTrue(app.staticTexts["Recording"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Play Recording"].exists)
        app.buttons["Back to Sessions"].tap()
        XCTAssertTrue(app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Audio Recording")).firstMatch.waitForExistence(timeout: 5))

        app.terminate()

        let relaunched = XCUIApplication()
        relaunched.launchArguments = ["-ui-testing"]
        relaunched.launch()
        XCTAssertTrue(relaunched.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Audio Recording")).firstMatch.waitForExistence(timeout: 5))
    }
}
