import UIKit
import RxSwift



protocol UserMvcComposerContract {}



class UserMvcComposer: UIViewController, UserMvcComposerContract {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!


    private var model: UserModelContract!
    private let disposeBag = RxSwift.DisposeBag()


    static func create(byModel model: UserModelContract) -> UserMvcComposer? {
        guard let viewController = R.storyboard.userScreen.userViewController() else {
            return nil
        }

        viewController.model = model

        return viewController
    }


    private var viewMediator: UserViewMediatorContract!


    override func viewDidLoad() {
        super.viewDidLoad()


        self.viewMediator = UserViewMediator(
            observing: self.model,
            handling: (
                avatarImageView: self.avatarImageView,
                progressView: self.progressView,
                titleHolder: ViewControllerTitleHolder(changeTitleOf: self)
            ),
            presentingModalBy: Lifter(wherePresentOn: self)
        )
    }
}
