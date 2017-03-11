import XCTest
import PromiseKit
@testable import TestableDesignExample


class GitHubApiTests: XCTestCase {
    func testFetch() {
        async(test: self, timeout: 5.0) {
            let registry = BootstrapResourceRegistryStubFactory.create()
            let api = GitHubApiClient(registry: registry)

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


    static var allTests : [(String, (GitHubApiTests) -> () throws -> Void)] {
        return [
             ("testFetch", self.testFetch),
        ]
    }
}