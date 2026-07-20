import XCTest

final class CuraUITests: XCTestCase {
    func testLaunchShowsFoundationCopy() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["CURA"].exists)
    }
}
