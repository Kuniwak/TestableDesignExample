import PromiseKit
@testable import TestableDesignExample



extension Bag {
    static func create(
        api: GitHubApiClientContract = GitHubApiClientStub.anyPending
    ) -> Bag {
        return Bag(api: api)
    }
}