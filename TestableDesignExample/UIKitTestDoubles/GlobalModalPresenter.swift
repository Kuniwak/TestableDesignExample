import UIKit



class GlobalModalPresenter: ModalPresenterContract {
    @discardableResult
    func present(viewController: UIViewController, animated: Bool) -> ModalDissolverContract {
        let window = UIWindow()
        let rootViewController = TransparentViewController()

        window.rootViewController = rootViewController
        window.makeKeyAndVisible()

        return ModalDissolver(willDismiss: rootViewController)
    }
}
