import XCTest
@testable import TestableDesignExample


class StargazersInfiniteScrollControllerTests: XCTestCase {
    func testTrigger() {
        let scrollView = self.createScrollView()

        awaitUntilVisible(on: self, testing: scrollView) { fulfill in
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

            scrollView.setContentOffset(
                CGPoint(x: 0, y: 200),
                animated: false
            )
        }
    }


    func testNotTrigger() {
        let scrollView = self.createScrollView()

        awaitUntilVisible(on: self, testing: scrollView) { fulfill in
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

            scrollView.setContentOffset(
                CGPoint(x: 0, y: 1),
                animated: false
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
