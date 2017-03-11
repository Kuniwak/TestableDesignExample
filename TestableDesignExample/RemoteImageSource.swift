import UIKit
import Dispatch
import RxSwift



class RemoteImageSource {
    private let stateVariable = Variable<State>(.pending)
    private let imageView: UIImageView


    var didChange: Observable<State> {
        return self.stateVariable.asObservable()
    }

    var currentState: State {
        return self.stateVariable.value
    }


    init(willUpdate imageView: UIImageView) {
        self.imageView = imageView
    }


    func fetch(from url: URL) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard error == nil else {
                self.transitState(to: .failure(reason: .networkError(debugInfo: "\(error)")))
                return
            }

            guard let data = data else {
                self.transitState(to: .failure(reason: .noData))
                return
            }

            guard let image = UIImage(data: data) else {
                self.transitState(to: .failure(reason: .brokenImage))
                return
            }

            self.set(image: image)

        })
        task.resume()
    }


    private func transitState(to nextState: State) {
        self.stateVariable.value = nextState
    }


    func set(image: UIImage) {
        self.imageView.image = image
        self.stateVariable.value = .success(image: image)
    }


    enum State {
        case pending
        case success(image: UIImage)
        case failure(reason: LoadingError)
    }


    enum LoadingError {
        case noData
        case brokenImage
        case networkError(debugInfo: String)
    }
}
