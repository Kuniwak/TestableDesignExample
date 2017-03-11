import Foundation
import PromiseKit
import Unbox



protocol GitHubApiClientContract {
    func fetch(endpoint: GitHubApiEndpoint, headers: [String: String], parameters: [(String, String)]) -> Promise<Data>
}



struct GitHubApiEndpoint {
    let path: String
}



struct GitHubApiClient: GitHubApiClientContract {
    private let registry: BootstrapResourceRegistryContract


    init (registry: BootstrapResourceRegistryContract) {
        self.registry = registry
    }


    func fetch(endpoint: GitHubApiEndpoint, headers: [String: String], parameters: [(String, String)]) -> Promise<Data> {
        guard var urlComponents = URLComponents(
            url: self.registry.gitHubApiUrl,
            resolvingAgainstBaseURL: false
        ) else {
            return Promise(error: NetworkError.malformedRequest(debugInfo: "\(endpoint)"))
        }

        urlComponents.path = endpoint.path
        urlComponents.queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
        }

        guard let url = urlComponents.url else {
            return Promise(error: NetworkError.malformedRequest(debugInfo: "\(endpoint)"))
        }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers

        return Promise<Data>(resolvers: { resolve, reject in
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, _, error in
                guard let data = data else {
                    reject(NetworkError.emptyResponse(debugInfo: "\(error)"))
                    return
                }

                if let error = error {
                    reject(NetworkError.unrecognizableResponse(debugInfo: "\(error)"))
                    return
                }

                resolve(data)
            })
            task.resume()
        })
    }



    enum NetworkError: Error {
        case unrecognizableResponse(debugInfo: String)
        case malformedRequest(debugInfo: String)
        case emptyResponse(debugInfo: String)
    }
}