import PromiseKit



struct StargazerRepository: PageRepositoryProtocol {
    typealias Element = GitHubUser
    private let api: GitHubApiClientProtocol
    private let gitHubRepository: GitHubRepository
    private let numberOfStargazersPerPage: Int


    init(
        for gitHubRepository: GitHubRepository,
        perPage numberOfStargazersPerPage: Int,
        fetchingVia api: GitHubApiClientProtocol
    ) {
        self.api = api
        self.numberOfStargazersPerPage = numberOfStargazersPerPage
        self.gitHubRepository = gitHubRepository
    }


    func fetch(pageOf pageNumber: Int) -> Promise<[Element]> {
        return GitHubStargazer.Page.fetch(
            stargazersOf: self.gitHubRepository,
            pageOf: pageNumber,
            perPage: self.numberOfStargazersPerPage,
            via: self.api
        )
    }
}