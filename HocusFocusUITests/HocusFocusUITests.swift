import XCTest

class HocusFocusUITests: XCTestCase {
   func testHoldToFocusMode() {
    let app = XCUIApplication()
    app.launch()

    let holdButton = app.buttons["HoldToFocusModeButton"]
    XCTAssertTrue(holdButton.exists)
    holdButton.tap()

    let holdTimer = app.otherElements["HoldToFocusTimer"]
    XCTAssertTrue(holdTimer.exists)

    holdTimer.press(forDuration: 10)

    let backButton = app.buttons["BackButton"]
    XCTAssertTrue(backButton.waitForExistence(timeout: 5))
    backButton.tap()

    let historyButton = app.buttons["SessionHistoryButton"]
    XCTAssertTrue(historyButton.waitForExistence(timeout: 5))
    historyButton.tap()

    let sessionCell = app.staticTexts["Hold to Focus"]
    XCTAssertTrue(sessionCell.waitForExistence(timeout: 5))
}
}