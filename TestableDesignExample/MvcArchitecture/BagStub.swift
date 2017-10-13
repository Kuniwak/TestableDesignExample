import PromiseKit
@testable import TestableDesignExample



extension Bag {
    static func create(
        api: GitHubApiClientProtocol = GitHubApiClientStub.anyPending
    ) -> Bag {
        return Bag(api: api)
    }
}