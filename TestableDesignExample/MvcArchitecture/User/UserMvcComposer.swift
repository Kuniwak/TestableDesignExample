import UIKit
import RxSwift



protocol UserMvcComposerContract {}



class UserMvcComposer: UIViewController, UserMvcComposerContract {
    private let model: UserModelContract

    private var viewMediator: UserViewMediatorContract?
    private let disposeBag = RxSwift.DisposeBag()


    init(representing model: UserModelContract) {
        self.model = model

        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder aDecoder: NSCoder) {
        return nil
    }


    override func loadView() {
        let rootView = UserScreenRootView()
        self.view = rootView

        self.viewMediator = UserViewMediator(
            observing: self.model,
            handling: (
                avatarImageView: rootView.imageView,
                progressView: rootView.progressView,
                titleHolder: ViewControllerTitleHolder(changeTitleOf: self)
            ),
            presentingModalBy: ModalPresenter(wherePresentOn: self)
        )
    }
}
