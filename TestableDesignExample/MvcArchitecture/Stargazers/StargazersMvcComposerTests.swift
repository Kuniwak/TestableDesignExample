import XCTest
import Foundation
import PromiseKit
@testable import TestableDesignExample


class StargazersMvcComposerTests: XCTestCase {
    func testCreate() {
        let testNavigator = TestNavigator(line: #line)

        let viewController = StargazersMvcComposer.create(
            byStargazersOf: GitHubRepository(
                owner: GitHubUser.Name(text: "octocat"),
                name: GitHubRepository.Name(text: "Hello-world")
            ),
            presenting: StargazersModelStub(
                withInitialState: .fetched(
                    stargazers: [],
                    error: nil
                )
            ),
            navigatingBy: testNavigator,
            holding: Bag.create()
        )

        testNavigator.navigateWithFallback(to: viewController, animated: false)
    }


    static var allTests : [(String, (StargazersMvcComposerTests) -> () throws -> Void)] {
        return [
             ("testCreate", self.testCreate),
        ]
    }
}