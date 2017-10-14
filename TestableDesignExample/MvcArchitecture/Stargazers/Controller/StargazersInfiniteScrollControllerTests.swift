import XCTest
@testable import TestableDesignExample


class StargazersInfiniteScrollControllerTests: XCTestCase {
    func testTrigger() {
        let scrollView = self.createScrollView()

        waitUntilViewDidLoad(on: self, testing: scrollView) {
            let scrollViewStub = RxCocoaInjectable.InjectableUIScrollView
                .createStub(of: scrollView)

            let modelSpy = StargazersModelSpy()

            let controller = StargazersInfiniteScrollController(
                watching: scrollViewStub.injectable,
                determiningBy: InfiniteScrollTriggerStub(
                    firstResult: true
                ),
                notifying: modelSpy
            )

            scrollViewStub.scroll()

            XCTAssertEqual(modelSpy.callArgs.count, 1)

            // NOTE: Hold reference
            _ = controller
        }
    }


    func testNotTrigger() {
        let scrollView = self.createScrollView()

        waitUntilViewDidLoad(on: self, testing: scrollView) {
            let scrollViewStub = RxCocoaInjectable.InjectableUIScrollView
                .createStub(of: scrollView)

            let modelSpy = StargazersModelSpy()

            let controller = StargazersInfiniteScrollController(
                watching: scrollViewStub.injectable,
                determiningBy: InfiniteScrollTriggerStub(
                    firstResult: false
                ),
                notifying: modelSpy
            )

            scrollViewStub.scroll()

            XCTAssertEqual(modelSpy.callArgs.count, 0)

            // NOTE: Hold reference
            _ = controller
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
