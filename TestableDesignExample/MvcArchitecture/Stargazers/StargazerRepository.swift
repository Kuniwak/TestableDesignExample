import PromiseKit



struct StargazerRepository: PageRepositoryContract {
    typealias Element = GitHubUser
    private let api: GitHubApiClientContract
    private let gitHubRepository: GitHubRepository
    private let numberOfStargazersPerPage: Int


    init(
        for gitHubRepository: GitHubRepository,
        perPage numberOfStargazersPerPage: Int,
        fetchingVia api: GitHubApiClientContract
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