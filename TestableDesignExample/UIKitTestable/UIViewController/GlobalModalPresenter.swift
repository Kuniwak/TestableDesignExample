import UIKit



protocol GlobalModalPresenterProtocol: ModalPresenterProtocol {
    var dissolver: ModalDissolverProtocol { get }
}



/**
 A class for specialized ModalPresenters that can present a UIViewController unconditionally.
 You can present a UIViewController if you does not know what UIViewController is visible.
 */
class GlobalModalPresenter: GlobalModalPresenterProtocol {
    private(set) var dissolver: ModalDissolverProtocol = NullModalDissolver()
    private let window = UIWindow()


    func present(viewController: UIViewController, animated: Bool) {
        self.present(viewController: viewController, animated: animated, completion: nil)
    }


    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        self.dissolver.dismiss(animated: animated)

        // NOTE: The created window will be disposed when the root UIViewController is dismissed.
        let rootViewController = TransparentViewController()
        self.dissolver = GlobalModalDissolver(
            window: self.window,
            rootViewController: rootViewController
        )

        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()

        rootViewController.present(
            viewController,
            animated: animated,
            completion: completion
        )
    }



    class GlobalModalDissolver: ModalDissolverProtocol {
        private let window: UIWindow
        private let rootViewController: UIViewController


        init(window: UIWindow, rootViewController: UIViewController) {
            self.window = window
            self.rootViewController = rootViewController
        }


        func dismiss(animated: Bool) {
            self.dismiss(animated: animated, completion: nil)
        }


        func dismiss(animated: Bool, completion: (() -> Void)?) {
            self.rootViewController.dismiss(
                animated: animated,
                completion: {
                    self.window.isHidden = true
                    completion?()
                })
        }
    }



    class NullModalDissolver: ModalDissolverProtocol {
        func dismiss(animated: Bool) {}
        func dismiss(animated: Bool, completion: (() -> Void)?) {
            completion?()
        }
    }
}
