import Foundation



struct GitHubApiEndpoint {
    let path: String
}



enum GitHubApiEndpointBaseUrl {
    static let gitHubCom = URL(string: "https://api.github.com/")!
}
