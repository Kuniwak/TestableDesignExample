import UIKit
@testable import TestableDesignExample



/**
 A stub class for ModalDissolvers.
 This class is useful for ignoring calls of `UIViewController#dismiss` for testing.
 */
class ModalDissolverStub: ModalDissolverContract {
    func dismiss(animated: Bool) {}
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        completion?()
    }
}
