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
            andFetchingStargazersVia: StargazerRepositoryStub(
                firstResult: Promise(value: [
                    GitHubUser(
                        name: GitHubUser.Name(text: "octocat"),
                        avatar: URL(string: "https://avatars3.githubusercontent.com/u/583231?v=3&s=400")!
                    ),
                ])
            ),
            andNavigateBy: testNavigator,
            andHolding: GitHubApiClientStub.anyPending
        )

        testNavigator.navigateWithFallback(to: viewController)
    }


    static var allTests : [(String, (StargazersMvcComposerTests) -> () throws -> Void)] {
        return [
             ("testCreate", self.testCreate),
        ]
    }
}