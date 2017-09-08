import UIKit



/**
 A type for encapsulating classes of `UIViewController#present(_: UIViewController, animated: Bool)`.
 */
protocol ModalPresenterContract {
    /**
     Presents a view controller modally.
     This method behave like `UIViewController#present(UIViewController, animated: Bool)`
     */
    @discardableResult
    func present(viewController: UIViewController, animated: Bool) -> ModalDissolverContract


    /**
     Presents a view controller modally.
     This method behave like `UIViewController#present(UIViewController, animated: Bool, completion: (() -> Void)?)`
     */
    @discardableResult
    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) -> ModalDissolverContract
}



/**
 A wrapper class to encapsulate a implementation of `UIViewController#present(_: UIViewController, animated: Bool)`.
 */
class ModalPresenter: ModalPresenterContract {
    private let groundViewController: UIViewController


    /**
     Return newly initialized ModalPresenter with the UIViewController.
     Some UIViewControllers will be present on the specified UIViewController of the function.
     */
    init(wherePresentOn groundViewController: UIViewController) {
        self.groundViewController = groundViewController
    }


    @discardableResult
    func present(viewController: UIViewController, animated: Bool) -> ModalDissolverContract {
        self.groundViewController.present(viewController, animated: animated)
        return ModalDissolver(willDismiss: viewController)
    }


    @discardableResult
    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) -> ModalDissolverContract {
        self.groundViewController.present(viewController, animated: animated, completion: completion)
        return ModalDissolver(willDismiss: viewController)
    }
}
