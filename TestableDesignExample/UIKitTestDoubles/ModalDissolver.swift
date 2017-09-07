import UIKit



protocol ModalDissolverContract {
    func dismiss(animated: Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}



class ModalDissolver: ModalDissolverContract {
    private let viewController: UIViewController


    init(willDismiss viewController: UIViewController) {
        self.viewController = viewController
    }


    func dismiss(animated: Bool) {
        self.viewController.dismiss(animated: animated)
    }


    func dismiss(animated: Bool, completion: (() -> Void)?) {
        self.viewController.dismiss(
            animated: animated,
            completion: completion
        )
    }
}
