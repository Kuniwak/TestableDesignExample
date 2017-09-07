import UIKit
@testable import TestableDesignExample



class ModalPresenterStub: ModalPresenterContract {
    func present(viewController: UIViewController, animated: Bool) {}
    func presentWithFallback(viewController: UIViewController?, animated: Bool) {}
}