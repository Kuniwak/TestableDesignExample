import UIKit
import RxSwift



protocol UserViewMvcComposerContract {}



class UserViewMvcComposer: UIViewController, UserViewMvcComposerContract {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!

    
    private var user: GitHubUser!
    private var imageSource: RemoteImageSource!
    private let disposeBag = RxSwift.DisposeBag()


    static func create(for user: GitHubUser) -> UserViewMvcComposer? {
        guard let viewController = R.storyboard.userScreen.userViewController() else {
            return nil
        }

        viewController.user = user

        return viewController
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "@\(self.user.name.text)"

        self.imageSource = RemoteImageSource(
            willUpdate: self.avatarImageView
        )
        self.progressView.isHidden = false

        // NOTE: This class is not so large, so View features are inside of the composer.
        self.imageSource
            .didChange
            .observeOn(RxSwift.MainScheduler.instance)
            .subscribe(onNext: { state in
                switch state {
                case .pending:
                    self.avatarImageView.backgroundColor = ColorCatalog.Weak.background
                    self.progressView.isHidden = false
                    self.progressView.setProgress(0.8, animated: true)
                case .success:
                    self.avatarImageView.backgroundColor = ColorCatalog.Default.background
                    self.progressView.isHidden = true
                case .failure:
                    self.avatarImageView.backgroundColor = ColorCatalog.Default.background
                    self.progressView.isHidden = true
                }
            })
            .addDisposableTo(self.disposeBag)

        self.imageSource.fetch(from: user.avatar)
    }
}
