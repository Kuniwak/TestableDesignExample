import UIKit



protocol GlobalModalPresenterContract {
    func present(viewController: UIViewController, animated: Bool) -> ModalDissolverContract
}



class GlobalModalPresenter: GlobalModalPresenterContract {
    func present(viewController: UIViewController, animated: Bool) -> ModalDissolverContract {
        let window = UIWindow()
        let rootViewController = TransparentViewController()

        window.rootViewController = rootViewController
        window.makeKeyAndVisible()

        return ModalDissolver(willDismiss: rootViewController)
    }
}
