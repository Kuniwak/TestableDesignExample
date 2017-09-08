import UIKit



/**
 A class for specialized ModalPresenters that can present a UIViewController unconditionally.
 You can present a UIViewController if you does not know what UIViewController is visible.
 */
class GlobalModalPresenter: ModalPresenterContract {
    @discardableResult
    func present(viewController: UIViewController, animated: Bool) -> ModalDissolverContract {
        let window = UIWindow()
        let rootViewController = TransparentViewController()

        window.rootViewController = rootViewController
        window.makeKeyAndVisible()

        // NOTE: The created window will be disposed when the root UIViewController is dismissed.
        return ModalDissolver(willDismiss: rootViewController)
    }
}
