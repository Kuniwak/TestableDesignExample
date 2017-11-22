import XCTest
@testable import TestableDesignExample


class StargazersNavigationViewBindingTests: XCTestCase {
    func testNavigate() {
        let tableView = UITableView()

        waitUntilViewDidLoad(on: self, testing: tableView) {
            let tableViewStub = RxCocoaInjectable.InjectableUITableView.createStub(of: tableView)
            let dataSourceStub = StargazersTableViewDataSourceStub(firstResult: [
                GitHubUserStub.create()
            ])

            let navigatorSpy = NavigatorSpy()

            let viewBinding = StargazersNavigationViewBinding(
                watching: tableViewStub.injectable,
                findingVisibleRowBy: dataSourceStub,
                navigatingBy: navigatorSpy,
                holding: Bag.createStub()
            )

            tableViewStub.selectItem(IndexPath(row: 0, section: 0))

            XCTAssertEqual(navigatorSpy.callArgs.count, 1)

            // NOTE: Hold reference
            _ = viewBinding
        }
    }
}

