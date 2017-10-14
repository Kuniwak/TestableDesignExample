import Foundation
@testable import TestableDesignExample



enum GitHubUserStub {
    static func create(
        id: GitHubUser.Id = .init(text: "any id"),
        name: GitHubUser.Name = .init(text: "any user"),
        avatar: URL = URL(string: "http://example.com/any-avatar.png")!
    ) -> GitHubUser {
        return GitHubUser(
            id: id,
            name: name,
            avatar: avatar
        )
    }
}