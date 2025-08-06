import XCTest
@testable import HocusFocus

class HocusFocusTests: XCTestCase {
    func testTimerLabelFormatter() {
        let formatter = TimerLabelFormatter()
        XCTAssertEqual(formatter.format(seconds: 0), "00:00")
        XCTAssertEqual(formatter.format(seconds: 60), "01:00")
        XCTAssertEqual(formatter.format(seconds: 125), "02:05")
        XCTAssertEqual(formatter.format(seconds: 3600), "60:00")
    }
}