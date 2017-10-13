import UIKit



/**
 A type for encapsulating classes of `UIViewController#present(_: UIViewController, animated: Bool)`.
 */
protocol ModalPresenterProtocol {
    /**
     Presents a view controller modally.
     This method behave like `UIViewController#present(UIViewController, animated: Bool)`
     */
    func present(viewController: UIViewController, animated: Bool)


    /**
     Presents a view controller modally.
     This method behave like `UIViewController#present(UIViewController, animated: Bool, completion: (() -> Void)?)`
     */
    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
}



/**
 A wrapper class to encapsulate a implementation of `UIViewController#present(_: UIViewController, animated: Bool)`.
 */
class ModalPresenter: ModalPresenterProtocol {
    private let groundViewController: UIViewController


    /**
     Return newly initialized ModalPresenter with the UIViewController.
     Some UIViewControllers will be present on the specified UIViewController of the function.
     */
    init(wherePresentOn groundViewController: UIViewController) {
        self.groundViewController = groundViewController
    }


    func present(viewController: UIViewController, animated: Bool) {
        self.groundViewController.present(viewController, animated: animated)
    }


    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        self.groundViewController.present(viewController, animated: animated, completion: completion)
    }
}
