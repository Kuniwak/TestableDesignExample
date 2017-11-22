import XCTest
import RxCocoa
@testable import TestableDesignExample


class StargazersRefreshControllerTests: XCTestCase {
    func testTrigger() {
        let relay = RxCocoa.PublishRelay<Void>()

        let modelSpy = StargazersModelSpy()

        let controller = StargazersRefreshController(
            watching: relay.asSignal(),
            notifying: modelSpy
        )

        // Simulate refresh
        relay.accept(())

        XCTAssertEqual(modelSpy.callArgs, [.clear, .fetchNext])

        // NOTE: Hold reference
        _ = controller
    }
}
