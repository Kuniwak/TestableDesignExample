import UIKit
@testable import TestableDesignExample



/**
 A stub class for GlobalModalPresenter.
 This class is useful for ignoring calls of `GlobalModalPresenter#present` for testing.
 */
class GlobalModalPresenterStub: GlobalModalPresenterProtocol {
    var dissolver: ModalDissolverProtocol


    init(exposing dissolver: ModalDissolverProtocol) {
        self.dissolver = dissolver
    }


    func present(viewController: UIViewController, animated: Bool) {}
    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        completion?()
    }
}