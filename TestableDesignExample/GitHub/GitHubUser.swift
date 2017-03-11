import Foundation
import Unbox



struct GitHubUser {
    let name: Name
    let avatar: URL


    struct Name {
        let text: String
    }
}



extension GitHubUser: Unboxable {
    init(unboxer: Unboxer) throws {
        self.name = try GitHubUser.Name(text: unboxer.unbox(key: "login"))
        self.avatar = try unboxer.unbox(key: "avatar_url")
    }
}
