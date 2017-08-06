import PromiseKit
@testable import TestableDesignExample



class StargazerRepositoryStub: PageRepositoryContract {
    typealias Element = GitHubUser
    var nextResult: Promise<[GitHubUser]>


    init(firstResult: Promise<[GitHubUser]>) {
        self.nextResult = firstResult
    }


    func fetch(pageOf pageNumber: Int) -> Promise<[GitHubUser]> {
        return self.nextResult
    }
}
