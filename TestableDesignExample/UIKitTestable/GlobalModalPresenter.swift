import UIKit



/**
 A class for specialized ModalPresenters that can present a UIViewController unconditionally.
 You can present a UIViewController if you does not know what UIViewController is visible.
 */
class GlobalModalPresenter: ModalPresenterContract {
    func present(viewController: UIViewController, animated: Bool) {
        self.present(viewController: viewController, animated: animated, completion: nil)
    }


    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        // NOTE: The created window will be disposed when the root UIViewController is dismissed.
        let window = UIWindow()
        let rootViewController = TransparentViewController()

        window.rootViewController = rootViewController
        window.makeKeyAndVisible()

        completion?()
    }
}
