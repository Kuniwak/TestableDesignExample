import XCTest
@testable import TestableDesignExample


class StargazersRefreshControllerTests: XCTestCase {
    func testTrigger() {
        let scrollView = self.createScrollView()
        let refreshControl = UIRefreshControl()
        scrollView.refreshControl = refreshControl

        waitUntilViewDidLoad(on: self, testing: scrollView) {
            let refreshControlStub = RxCocoaInjectable.InjectableUIRefreshControl
                .createStub(of: refreshControl)

            let modelSpy = StargazersModelSpy()

            let controller = StargazersRefreshController(
                watching: refreshControlStub.injectable,
                notifying: modelSpy
            )

            refreshControlStub.refresh()

            XCTAssertEqual(modelSpy.callArgs, [.clear, .fetchNext])

            // NOTE: Hold reference
            _ = controller
        }
    }


    private func createScrollView() -> UIScrollView {
        let views = UIScrollView.create()
        return views.scrollView
    }
}
