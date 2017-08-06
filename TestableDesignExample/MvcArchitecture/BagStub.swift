import PromiseKit
@testable import TestableDesignExample



extension Bag {
    static func create(
        api: GitHubApiClientContract = GitHubApiClientStub(
            firstResult: Promise<Any>.pending().promise
        )
    ) -> Bag {
        return Bag(api: api)
    }
}