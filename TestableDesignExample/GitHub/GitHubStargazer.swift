import PromiseKit
import Unbox



struct GitHubStargazer {
    static func fetch(
        stargazersOf repository: GitHubRepository,
        via api: GitHubApiClientContract
    ) -> Promise<[GitHubUser]> {
        return api.fetch(
                endpoint: GitHubApiEndpoint(path: "/repos/\(repository.owner.text)/\(repository.name.text)/stargazers"),
                headers: [:],
                parameters: []
            )
            .then { data -> [GitHubUser] in
                let users: [GitHubUser] = try unbox(data: data)
                return users
            }
    }
}