import UIKit
@testable import TestableDesignExample



class NavigatorSpy: NavigatorContract {
    typealias CallArgs = (viewController: UIViewController, animated: Bool)
    fileprivate(set) var callArgs: [CallArgs] = []


    func navigate(to viewController: UIViewController, animated: Bool) {
        let callArgs = (viewController: viewController, animated: animated)
        self.callArgs.append(callArgs)
    }
}
