import XCTest
@testable import TestableDesignExample


class RootNavigatorTests: XCTestCase {
    func testNavigateToRoot() {
        let spy = RootViewControllerHolderSpy()
        let rootNavigator = RootNavigator(using: spy)

        rootNavigator.navigateToRoot()

        XCTAssertEqual(spy.callArgs.count, 1)
    }
}