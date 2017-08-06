import UIKit
import RxSwift



protocol UserViewMediatorContract {}



class UserViewMediator: UserViewMediatorContract {
    private let disposeBag = RxSwift.DisposeBag()
    private let model: UserModelContract
    private let imageSource: RemoteImageSource
    private let views: Views
    typealias Views = (
        progressView: UIProgressView,
        avatarImageView: UIImageView,
        titleHolder: TitleHolder
    )


    init(
        observing model: UserModelContract,
        handling views: Views
    ) {
        self.model = model
        self.views = views
        self.imageSource = RemoteImageSource(willUpdate: views.avatarImageView)

        self.model.didChange
            .subscribe(onNext: { [weak self] state in
                guard let this = self else { return }

                switch state {
                case .fetching:
                    this.views.titleHolder.setTitle(text: "Loading...")
                    this.imageSource.set(image: UIImage())

                case let .fetched(result: .success(user)):
                    this.views.titleHolder.setTitle(text: user.name.text)
                    this.imageSource.fetch(from: user.avatar)

                case let .fetched(result: .failure(error)):
                    dump(error)

                    this.views.titleHolder.setTitle(text: "Error")
                    this.imageSource.set(image: UIImage())
                }
            })
            .addDisposableTo(self.disposeBag)

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
            .addDisposableTo(self.disposeBag)
    }
}