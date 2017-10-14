@testable import TestableDesignExample


class StargazersTableViewDataSourceStub: StargazersTableViewDataSourceProtocol {
    var visibleStargazers: [GitHubUser] {
        return self.nextResult
    }


    var nextResult: [GitHubUser]


    init(firstResult: [GitHubUser]) {
        self.nextResult = firstResult
    }
}