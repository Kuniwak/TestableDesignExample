import PromiseKit
import Unbox



protocol UserRepositoryProtocol {
    func get(by id: GitHubUser.Id) -> Promise<GitHubUser>
}



class UserApiRepository: UserRepositoryProtocol {
    private let api: GitHubApiClientProtocol


    init(fetchingVia api: GitHubApiClientProtocol) {
        self.api = api
    }


    func get(by id: GitHubUser.Id) -> Promise<GitHubUser> {
        return self.api
            .fetch(
                endpoint: GitHubApiEndpoint(path: "/user/" + id.text),
                headers: [:],
                parameters: []
            )
            .map { data -> GitHubUser in
                let response: GitHubUserResponse = try unbox(data: data)
                return response.user
            }
    }
}



private class GitHubUserResponse: Unboxable {
    let user: GitHubUser


    required init(unboxer: Unboxer) throws {
        self.user = try GitHubUser(
            id: GitHubUser.Id(text: unboxer.unbox(key: "id")),
            name: GitHubUser.Name(text: unboxer.unbox(key: "login")),
            avatar: unboxer.unbox(key: "avatar_url")
        )
    }
}
