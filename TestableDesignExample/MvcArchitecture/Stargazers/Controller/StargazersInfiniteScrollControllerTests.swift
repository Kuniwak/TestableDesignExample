import XCTest
import RxCocoa
@testable import TestableDesignExample


class StargazersInfiniteScrollControllerTests: XCTestCase {
    func testTrigger() {
        let scrollView = UIScrollView()

        waitUntilViewDidLoad(on: self, testing: scrollView) {
            let relay = RxCocoa.PublishRelay<Void>()
            let modelSpy = StargazersModelSpy()

            let controller = StargazersInfiniteScrollController(
                watching: relay.asSignal(),
                handling: scrollView,
                determiningBy: InfiniteScrollTriggerStub(
                    firstResult: true
                ),
                notifying: modelSpy
            )

            // Simulate scrolling
            relay.accept(())

            XCTAssertEqual(modelSpy.callArgs.count, 1)

            // NOTE: Hold reference
            _ = controller
        }
    }


    func testNotTrigger() {
        let scrollView = UIScrollView()

        waitUntilViewDidLoad(on: self, testing: scrollView) {
            let relay = PublishRelay<Void>()
            let modelSpy = StargazersModelSpy()

            let controller = StargazersInfiniteScrollController(
                watching: relay.asSignal(),
                handling: scrollView,
                determiningBy: InfiniteScrollTriggerStub(
                    firstResult: false
                ),
                notifying: modelSpy
            )

            // Simulate scrolling
            relay.accept(())

            XCTAssertEqual(modelSpy.callArgs.count, 0)

            // NOTE: Hold reference
            _ = controller
        }
    }
}
