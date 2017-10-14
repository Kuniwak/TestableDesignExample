import XCTest
@testable import TestableDesignExample


class StargazersNavigationViewMediatorTests: XCTestCase {
    func testNavigate() {
        let tableView = UITableView()

        waitUntilViewDidLoad(on: self, testing: tableView) { fulfill in
            let navigatorSpy = NavigatorSpy()
            let dataSourceStub = StargazersTableViewDataSourceStub(firstResult: [
                GitHubUserStub.create()
            ])

            let viewMediator = StargazersNavigationViewMediator(
                watching: tableView,
                findingVisibleRowBy: dataSourceStub,
                navigatingBy: navigatorSpy
            )

            viewMediator.didHandle = {
                XCTAssertEqual(navigatorSpy.callArgs.count, 1)
                fulfill()
            }

            EventSimulator.simulateSelect(
                on: tableView,
                at: IndexPath(
                    row: 0,
                    section: 0
                )
            )
        }
    }
}

