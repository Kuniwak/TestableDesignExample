import UIKit
import RxSwift



protocol UserMvcComposerProtocol {}



class UserMvcComposer: UIViewController, UserMvcComposerProtocol {
    private let model: UserModelProtocol

    private var viewMediator: UserViewMediatorProtocol?
    private let disposeBag = RxSwift.DisposeBag()


    init(representing model: UserModelProtocol) {
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
