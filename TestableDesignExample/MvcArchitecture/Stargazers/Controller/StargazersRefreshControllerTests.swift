import XCTest
@testable import TestableDesignExample


class StargazersRefreshControllerTests: XCTestCase {
    func testTrigger() {
        let scrollView = self.createScrollView()
        let refreshControl = UIRefreshControl()

        scrollView.refreshControl = refreshControl

        waitUntilVisible(on: self, testing: scrollView) { fulfill in
            let spy = StargazersModelSpy()
            let controller = StargazersRefreshController(
                watching: refreshControl,
                notifying: spy
            )

            controller.didHandle = {
                XCTAssertEqual(spy.callArgs, [.clear, .fetchNext])
                fulfill()
            }

            EventSimulator.simulateBeginRefreshing(on: refreshControl)
        }
    }


    private func createScrollView() -> UIScrollView {
        let views = UIScrollView.create()
        return views.scrollView
    }
}

