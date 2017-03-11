import XCTest
import PromiseKit
import MirrorDiffKit
@testable import TestableDesignExample


class GitHubStarredRepositoryTests: XCTestCase {
    func testFetch() {
        async(test: self, line: #line) {
            let response = JsonReader.array(from: R.file.reposStargazersJson.path()!)
            let apiStub = GitHubApiClientStub(firstResult: Promise(value: response))
            let repository = GitHubRepository(
                owner: GitHubUser.Name(text: "octocat"),
                name: GitHubRepository.Name(text: "Hello-world")
            )

            return GitHubStargazer.fetch(stargazersOf: repository, via: apiStub)
                .then { repositories -> Void in
                    let expected = [
                        GitHubUser(
                            name: GitHubUser.Name(text: "octocat"),
                            avatar: URL(string: "https://github.com/images/error/octocat_happy.gif")!
                        ),
                    ]

                    XCTAssertTrue(
                        Diffable.from(repositories) =~ Diffable.from(expected),
                        diff(between: repositories, and: expected)
                    )
                }
        }
    }


    static var allTests : [(String, (GitHubStarredRepositoryTests) -> () throws -> Void)] {
        return [
             ("testFetch", self.testFetch),
        ]
    }
}