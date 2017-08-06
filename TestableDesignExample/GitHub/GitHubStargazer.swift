import PromiseKit
import Unbox



enum GitHubStargazer {
    enum Page {
        static func fetch(
            stargazersOf repository: GitHubRepository,
            pageOf pageNumber: Int,
            perPage numberOfElementsPerPage: Int,
            via api: GitHubApiClientContract
        ) -> Promise<[GitHubUser]> {
            return api.fetch(
                    endpoint: GitHubApiEndpoint(path: "/repos/\(repository.owner.text)/\(repository.name.text)/stargazers"),
                    headers: [:],
                    parameters: [
                        ("page", "\(pageNumber)"),
                        ("per_page", "\(numberOfElementsPerPage)"),
                    ]
                )
                .then { data -> [GitHubUser] in
                    let users: [GitHubUser] = try unbox(data: data)
                    return users
                }
        }
    }
}