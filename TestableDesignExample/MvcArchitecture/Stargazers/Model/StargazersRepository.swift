import PromiseKit
import Unbox



struct StargazersRepository: PageRepositoryProtocol {
    typealias Element = GitHubStargazer
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


    func fetch(pageOf pageNumber: Int) -> Promise<[GitHubStargazer]> {
        let path = "/repos/\(self.gitHubRepository.owner.text)/\(self.gitHubRepository.name.text)/stargazers"

        return api.fetch(
                endpoint: GitHubApiEndpoint(path: path),
                headers: [:],
                parameters: [
                    ("page", "\(pageNumber)"),
                    ("per_page", "\(self.numberOfStargazersPerPage)"),
                ]
            )
            .then { data -> [GitHubStargazer] in
                let users: [GitHubStargazerResponse] = try unbox(data: data)
                return users.map { $0.user }
            }
    }
}



private class GitHubStargazerResponse: Unboxable {
    let user: GitHubStargazer


    required init(unboxer: Unboxer) throws {
        self.user = try GitHubUser(
            id: GitHubUser.Id(text: unboxer.unbox(key: "id")),
            name: GitHubUser.Name(text: unboxer.unbox(key: "login")),
            avatar: unboxer.unbox(key: "avatar_url")
        )
    }
}
