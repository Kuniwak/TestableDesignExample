import UIKit
@testable import TestableDesignExample



/**
 A stub class for ModalPresenters.
 This class is useful for ignoring calls of `UIViewController#present` for testing.
 */
class ModalPresenterStub: ModalPresenterContract {
    func present(viewController: UIViewController, animated: Bool) {}
    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        completion?()
    }
}