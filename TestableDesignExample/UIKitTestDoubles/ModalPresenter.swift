import UIKit



protocol ModalPresenterContract {
    @discardableResult
    func present(viewController: UIViewController, animated: Bool) -> ModalDissolverContract
}



class ModalPresenter: ModalPresenterContract {
    private let groundViewController: UIViewController


    init(wherePresentOn groundViewController: UIViewController) {
        self.groundViewController = groundViewController
    }


    @discardableResult
    func present(viewController: UIViewController, animated: Bool) -> ModalDissolverContract {
        self.groundViewController.present(viewController, animated: animated)
        return ModalDissolver(willDismiss: viewController)
    }
}
