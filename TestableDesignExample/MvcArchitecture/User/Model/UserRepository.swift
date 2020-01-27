import PromiseKit



protocol UserRepositoryProtocol {
    func get(by id: GitHubUser.Id) -> Promise<GitHubUser>
}



class UserApiRepository: UserRepositoryProtocol {
    private let api: GitHubApiClientProtocol


    init(fetchingVia api: GitHubApiClientProtocol) {
        self.api = api
    }


    func get(by id: GitHubUser.Id) -> Promise<GitHubUser> {
        self.api
            .fetch(
                endpoint: GitHubApiEndpoint(path: "/user/" + String(id.integer)),
                headers: [:],
                parameters: []
            )
            .then { data throws -> Promise<GitHubUser> in
                let response = try JSONDecoder().decode(GitHubUserResponse.self, from: data)
                return .value(response.user)
            }
    }
}



private class GitHubUserResponse: Codable {
    let user: GitHubUser


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
