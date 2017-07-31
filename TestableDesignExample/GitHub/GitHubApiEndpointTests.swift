import XCTest
@testable import TestableDesignExample


class GitHubApiEndpointTests: XCTestCase {
    func testEndpointBaseIsNotNil() {
        XCTAssertNotNil(GitHubApiEndpointBaseUrl.gitHubCom)
    }



    static var allTests: [(String, (GitHubApiEndpointTests) -> () throws -> Void)] {
        return [
            ("testEndpointBaseIsNotNil", self.testEndpointBaseIsNotNil),
        ]
    }
}

