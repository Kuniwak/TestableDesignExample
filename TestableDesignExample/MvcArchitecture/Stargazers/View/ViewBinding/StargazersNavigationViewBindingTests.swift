import XCTest
import RxCocoa
@testable import TestableDesignExample


class StargazersNavigationViewBindingTests: XCTestCase {
    func testNavigate() {
        let tableView = UITableView()

        waitUntilViewDidLoad(on: self, testing: tableView) {
            let relay = RxCocoa.PublishRelay<IndexPath>()
            let dataSourceStub = StargazersTableViewDataSourceStub(firstResult: [
                GitHubUserStub.create()
            ])

            let navigatorSpy = NavigatorSpy()

            let viewBinding = StargazersNavigationViewBinding(
                watching: relay.asSignal(),
                handling: tableView,
                findingVisibleRowBy: dataSourceStub,
                navigatingBy: navigatorSpy,
                holding: Bag.createStub()
            )
            
            // Simulate selecting
            relay.accept(IndexPath(row: 0, section: 0))

            XCTAssertEqual(navigatorSpy.callArgs.count, 1)

            // NOTE: Hold reference
            _ = viewBinding
        }
    }
}

