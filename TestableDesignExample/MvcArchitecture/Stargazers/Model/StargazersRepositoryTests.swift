import XCTest
import PromiseKit
import MirrorDiffKit
@testable import TestableDesignExample


class StargazersApiRepositoryTests: XCTestCase {
    func testFetch() {
        async(test: self, line: #line) {
            let response = JsonReader.array(from: R.file.reposStargazersJson.path()!)
            let apiStub = GitHubApiClientStub(firstResult: .value(response))

            let repository = StargazersRepository(
                for: GitHubRepository(
                    owner: GitHubUser.Name(text: "octocat"),
                    name: GitHubRepository.Name(text: "Hello-world")
                ),
                perPage: 1,
                fetchingVia: apiStub
            )

            return repository
                .fetch(pageOf: 1)
                .done { stargazers in
                    let expected = [
                        GitHubUser(
                            id: GitHubUser.Id(integer: 1),
                            name: GitHubUser.Name(text: "octocat"),
                            avatar: URL(string: "https://github.com/images/error/octocat_happy.gif")!
                        ),
                    ]

                    XCTAssert(
                        stargazers =~ expected,
                        diff(between: expected, and: stargazers)
                    )
                }
        }
    }
}