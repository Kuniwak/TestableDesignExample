import PromiseKit
@testable import TestableDesignExample



extension Bag {
    static func createStub(
        api: GitHubApiClientProtocol = GitHubApiClientStub.anyPending
    ) -> Bag {
        return Bag(api: api)
    }
}