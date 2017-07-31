import Foundation
import PromiseKit
import Unbox



protocol GitHubApiClientContract {
    func fetch(endpoint: GitHubApiEndpoint, headers: [String: String], parameters: [(String, String)]) -> Promise<Data>
}



/**
 Fetch a Data via GitHub API.
 You can use a stub for this class by using `GitHubApiClientStub`.

 # Usage
 ## For production code

 ```
 struct Something {
     let foo: String


     static func fetch(via api: GitHubApiClientContract) -> Promise<Something> {
         return api
             .fetch(
                 endpoint: GitHubApiEndpoint(path: "/something"),
                 headers: [:],
                 parameters: []
             )
             .then { data -> Something in
                 let something: Something = try unbox(data: data)
                 return something
             }
     }
 }
 ```


 ## For unit-testing code

 ```
 class SomethingTest: XCTestCase {
     func testFetch() {
         async(test: self, line: #line) {
             let response = ["foo": "bar"]
             let apiStub = GitHubApiClientStub(
                 firstResult: Promise(value: response)
             )

             return Something
                 .fetch(via: apiStub)
                 .then { something in
                     let expected = Something(foo: "bar")

                     XCTAssertEqual(something, expected)
                 }
         }
     }
 }
 ```
 */
struct GitHubApiClient: GitHubApiClientContract {
    private let base: URL


    init(basedOn url: URL) {
        self.base = url
    }


    func fetch(endpoint: GitHubApiEndpoint, headers: [String: String], parameters: [(String, String)]) -> Promise<Data> {
        guard var urlComponents = URLComponents(
            url: self.base,
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
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                guard let data = data else {
                    reject(NetworkError.emptyResponse(debugInfo: "data is nil (error=\(error.debugDescription))"))
                    return
                }

                guard let response = response as? HTTPURLResponse else {
                    reject(NetworkError.unrecognizableResponse(debugInfo: "protocol is not HTTP(S)"))
                    return
                }

                guard 200..<300 ~= response.statusCode else {
                    reject(NetworkError.unacceptableStatusCode(debugInfo: "Returned failed HTTP(S) status code: \(response.statusCode) "))
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
        case unacceptableStatusCode(debugInfo: String)
        case malformedRequest(debugInfo: String)
        case emptyResponse(debugInfo: String)
    }
}