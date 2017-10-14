import XCTest
@testable import TestableDesignExample


class StargazersInfiniteScrollControllerTests: XCTestCase {
    func testTrigger() {
        let scrollView = self.createScrollView()

        waitUntilViewDidLoad(on: self, testing: scrollView) { fulfill in
            let spy = StargazersModelSpy()

            let controller = StargazersInfiniteScrollController(
                watching: scrollView,
                determiningBy: InfiniteScrollTriggerStub(
                    firstResult: true
                ),
                notifying: spy
            )

            controller.didHandle = {
                XCTAssertEqual(spy.callArgs.count, 1)
                fulfill()
            }

            EventSimulator.simulateScroll(
                on: scrollView,
                to: CGPoint(x: 0, y: 200)
            )
        }
    }


    func testNotTrigger() {
        let scrollView = self.createScrollView()

        waitUntilViewDidLoad(on: self, testing: scrollView) { fulfill in
            let spy = StargazersModelSpy()

            let controller = StargazersInfiniteScrollController(
                watching: scrollView,
                determiningBy: InfiniteScrollTriggerStub(
                    firstResult: false
                ),
                notifying: spy
            )

            controller.didHandle = {
                XCTAssertEqual(spy.callArgs.count, 0)
                fulfill()
            }

            EventSimulator.simulateScroll(
                on: scrollView,
                to: CGPoint(x: 0, y: 1)
            )
        }
    }


    private func createScrollView() -> UIScrollView {
        let screenWidth: CGFloat = 100
        let screenHeight = PerformanceParameter.stargazersInfiniteScrollThreshold

        let views = UIScrollView.create(
            sizeOf: (
                scrollView: CGSize(width: screenWidth, height: screenHeight),
                contentView: CGSize(width: screenWidth, height: screenHeight * 2)
            ),
            scrolledAt: .zero
        )

        return views.scrollView
    }
}
