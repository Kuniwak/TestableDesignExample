import PromiseKit
@testable import TestableDesignExample



class StargazerRepositoryStub: StargazerRepositoryContract {
    var nextResult: Promise<[GitHubUser]>


    init(firstResult: Promise<[GitHubUser]>) {
        self.nextResult = firstResult
    }


    func get(stargazersOf: GitHubRepository) -> Promise<[GitHubUser]> {
        return self.nextResult
    }
}
