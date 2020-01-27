import Foundation



struct GitHubUser {
    let id: Id
    let name: Name
    let avatar: URL


    struct Name {
        let text: String
    }


    struct Id: Hashable {
        let integer: Int
    }
}



extension GitHubUser: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }

    static func ==(lhs: GitHubUser, rhs: GitHubUser) -> Bool { lhs.id == rhs.id }
}
