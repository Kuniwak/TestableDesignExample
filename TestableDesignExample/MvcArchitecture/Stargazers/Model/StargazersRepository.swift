import Foundation
import PromiseKit



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
            .then { data throws -> Promise<[GitHubStargazer]> in
                let users = try JSONDecoder().decode([GitHubStargazerResponse].self, from: data)
                return .value(users.map { $0.user })
            }
    }
}



private class GitHubStargazerResponse: Codable {
    let user: GitHubStargazer


    private enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
    }


    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user = try GitHubUser(
            id: GitHubUser.Id(integer: container.decode(Int.self, forKey: .id)),
            name: GitHubUser.Name(text: container.decode(String.self, forKey: .login)),
            avatar: container.decode(URL.self, forKey: .avatarUrl)
        )
    }


    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.user.id.integer, forKey: .id)
        try container.encode(self.user.name.text, forKey: .login)
        try container.encode(self.user.avatar, forKey: .avatarUrl)
    }
}
