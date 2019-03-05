import Foundation



struct GitHubUser {
    let id: Id
    let name: Name
    let avatar: URL


    struct Name {
        let text: String
    }


    struct Id {
        let text: String
    }
}



extension GitHubUser: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id.hashValue)
    }


    static func ==(lhs: GitHubUser, rhs: GitHubUser) -> Bool {
        return lhs.id == rhs.id
    }
}



extension GitHubUser.Id: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.text.hashValue)
    }


    public static func ==(lhs: GitHubUser.Id, rhs: GitHubUser.Id) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
