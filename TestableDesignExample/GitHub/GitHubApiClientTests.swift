import XCTest
import PromiseKit
@testable import TestableDesignExample


class GitHubApiTests: XCTestCase {
    /* SKIP: Because it frequently reaches GitHub API Limit.
    func testFetch() {
        async(test: self, timeout: 5.0) {
            let api = GitHubApiClient(basedOn: GitHubApiEndpointBaseUrl.gitHubCom)

            return api.fetch(
                    endpoint: GitHubApiEndpoint(path: "/zen"),
                    headers: [:],
                    parameters: []
                )
                .then { _ in
                    return
                }
        }
    }
    */


    static var allTests : [(String, (GitHubApiTests) -> () throws -> Void)] {
        return [
             // ("testFetch", self.testFetch),
        ]
    }
}