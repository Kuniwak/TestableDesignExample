import UIKit
@testable import TestableDesignExample



/**
 A stub class for GlobalModalPresenter.
 This class is useful for ignoring calls of `GlobalModalPresenter#present` for testing.
 */
class GlobalModalPresenterStub: GlobalModalPresenterContract {
    var dissolver: ModalDissolverContract


    init(exposing dissolver: ModalDissolverContract) {
        self.dissolver = dissolver
    }


    func present(viewController: UIViewController, animated: Bool) {}
    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        completion?()
    }
}