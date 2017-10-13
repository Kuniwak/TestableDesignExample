import UIKit
import RxSwift



protocol UserViewMediatorProtocol {}



class UserViewMediator: UserViewMediatorProtocol {
    private let disposeBag = RxSwift.DisposeBag()
    private let model: UserModelProtocol
    private let imageSource: RemoteImageSource
    private let views: Views
    typealias Views = (
        progressView: UIProgressView,
        avatarImageView: UIImageView,
        titleHolder: TitleHolder
    )
    private let lifter: ModalPresenterProtocol


    init(
        observing model: UserModelProtocol,
        handling views: Views,
        presentingModalBy lifter: ModalPresenterProtocol
    ) {
        self.model = model
        self.views = views
        self.lifter = lifter
        self.imageSource = RemoteImageSource(willUpdate: views.avatarImageView)

        self.model.didChange
            .subscribe(onNext: { [weak self] state in
                guard let this = self else { return }

                switch state {
                case .fetching:
                    this.views.titleHolder.setTitle(text: "Loading...")
                    this.imageSource.set(image: nil)

                case let .fetched(result: .success(user)):
                    this.views.titleHolder.setTitle(text: user.name.text)
                    this.imageSource.fetch(from: user.avatar)

                case let .fetched(result: .failure(error)):
                    dump(error)

                    this.present(error: error)

                    this.views.titleHolder.setTitle(text: "Error")
                    this.imageSource.set(image: nil)
                }
            })
            .disposed(by: self.disposeBag)

        self.views.progressView.isHidden = false

        self.imageSource
            .didChange
            .observeOn(RxSwift.MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                guard let views = self?.views else { return }

                switch state {
                case .pending:
                    views.avatarImageView.backgroundColor = UIColor.clear
                    views.progressView.isHidden = false
                    views.progressView.setProgress(0.8, animated: true)

                case .success:
                    views.avatarImageView.backgroundColor = ColorCatalog.Default.background
                    views.progressView.isHidden = true

                case .failure:
                    views.avatarImageView.backgroundColor = ColorCatalog.Default.background
                    views.progressView.isHidden = true
                }
            })
            .disposed(by: self.disposeBag)
    }


    private func present(error: UserModelState.ModelError) {
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