import Unbox



struct GitHubRepository {
    let owner: GitHubUser.Name
    let name: Name


    struct Name {
        let text: String
    }


    var text: String {
        return "\(self.owner.text)/\(self.name.text)"
    }
}



extension GitHubRepository: Unboxable {
    init(unboxer: Unboxer) throws {
        self.owner = try GitHubUser.Name(text: unboxer.unbox(keyPath: "owner.login"))
        self.name = try GitHubRepository.Name(text: unboxer.unbox(key: "name"))
    }
}
