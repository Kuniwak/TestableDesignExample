import UIKit
@testable import TestableDesignExample



class ModalPresenterStub: ModalPresenterContract {
    @discardableResult
    func present(viewController: UIViewController, animated: Bool) -> ModalDissolverContract {
        return ModalDissolverStub()
    }
}