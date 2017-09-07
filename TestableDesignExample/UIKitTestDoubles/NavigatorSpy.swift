import UIKit
@testable import TestableDesignExample



class NavigatorSpy: NavigatorContract {
    fileprivate(set) var callArgs = (
        ofNavigate: [(viewController: UIViewController, animated: Bool)](),
        ofNavigateWithFallback: [(viewController: UIViewController?, animated: Bool)]()
    )


    func navigate(to viewController: UIViewController, animated: Bool) {
        let callArgs = (viewController: viewController, animated: animated)
        self.callArgs.ofNavigate.append(callArgs)
    }


    func navigateWithFallback(to viewController: UIViewController?, animated: Bool) {
        let callArgs = (viewController: viewController, animated: animated)
        self.callArgs.ofNavigateWithFallback.append(callArgs)
    }
}
