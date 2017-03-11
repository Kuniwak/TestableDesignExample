import PromiseKit



protocol StargazerRepositoryContract {
    func get(stargazersOf repository: GitHubRepository) -> Promise<[GitHubUser]>
}



struct StargazerRepository: StargazerRepositoryContract {
    private let api: GitHubApiClientContract


    init(api: GitHubApiClientContract) {
        self.api = api
    }


    func get(stargazersOf repository: GitHubRepository) -> Promise<[GitHubUser]> {
        return GitHubStargazer.fetch(
            stargazersOf: repository,
            via: self.api
        )
    }
}