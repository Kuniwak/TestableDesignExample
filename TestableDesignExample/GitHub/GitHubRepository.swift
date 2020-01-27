struct GitHubRepository {
    let owner: GitHubUser.Name
    let name: Name


    struct Name {
        let text: String
    }


    var text: String { "\(self.owner.text)/\(self.name.text)" }
}
