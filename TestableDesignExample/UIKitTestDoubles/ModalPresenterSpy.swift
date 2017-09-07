import UIKit
@testable import TestableDesignExample



class ModalPresenterSpy: ModalPresenterContract {
    fileprivate(set) var callArgs = (
        ofPresent: [(viewController: UIViewController, animated: Bool)](),
        ofPresentWithFallback: [(viewController: UIViewController?, animated: Bool)]()
    )


    func present(viewController: UIViewController, animated: Bool) {
        let callArgs = (viewController: viewController, animated: animated)
        self.callArgs.ofPresent.append(callArgs)
    }


    func presentWithFallback(viewController: UIViewController?, animated: Bool) {
        let callArgs = (viewController: viewController, animated: animated)
        self.callArgs.ofPresentWithFallback.append(callArgs)
    }
}
