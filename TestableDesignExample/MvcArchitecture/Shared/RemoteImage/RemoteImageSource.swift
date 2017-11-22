import UIKit
import Dispatch
import RxSwift
import RxCocoa



class RemoteImageSource {
    private let stateVariable = RxCocoa.BehaviorRelay<State>(value: .pending)
    private let imageView: UIImageView


    var didChange: RxCocoa.Driver<State> {
        return self.stateVariable.asDriver()
    }

    var currentState: State {
        get { return self.stateVariable.value }
        set { self.stateVariable.accept(newValue) }
    }


    init(willUpdate imageView: UIImageView) {
        self.imageView = imageView
    }


    func fetch(from url: URL) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    self.currentState = .failure(reason: .networkError(debugInfo: "\(error.debugDescription)"))
                    return
                }

                guard let data = data else {
                    self.currentState = .failure(reason: .noData)
                    return
                }

                guard let image = UIImage(data: data) else {
                    self.currentState = .failure(reason: .brokenImage)
                    return
                }

                self.set(image: image)
            }
        })
        task.resume()
    }


    func set(image: UIImage?) {
        self.imageView.image = image
        self.stateVariable.accept(.success(image: image))
    }


    enum State {
        case pending
        case success(image: UIImage?)
        case failure(reason: LoadingError)
    }


    enum LoadingError {
        case noData
        case brokenImage
        case networkError(debugInfo: String)
    }
}
