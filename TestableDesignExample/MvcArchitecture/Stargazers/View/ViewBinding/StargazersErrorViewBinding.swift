import UIKit
import RxSwift


protocol StargazersErrorViewBindingProtocol {}


class StargazersErrorViewBinding: StargazersErrorViewBindingProtocol {
    private let disposeBag = RxSwift.DisposeBag()
    private let model: StargazersModelProtocol
    private let lifter: ModalPresenterProtocol


    init(
        observing model: StargazersModelProtocol,
        presentingAlertBy lifter: ModalPresenterProtocol
    ) {
        self.model = model
        self.lifter = lifter

        self.model
            .didChange
            .subscribe(onNext: { [weak self] state in
                guard let this = self else { return }

                switch state {
                case .fetching, .fetched(stargazers: _, error: .none):
                    return

                case let .fetched(stargazers: _, error: .some(error)):
                    this.present(error: error)
                }
            })
            .disposed(by: self.disposeBag)
    }


    func present(error: StargazersModelState.FailureReason) {
        let alertController = UIAlertController(
            title: "Error",
            message: "\(error)",
            preferredStyle: .alert
        )

        let goingBackAction = UIAlertAction(
            title: "Back",
            style: .cancel
        )

        alertController.addAction(goingBackAction)
        alertController.preferredAction = goingBackAction

        self.lifter.present(
            viewController: alertController,
            animated: true
        )
    }
}