import UIKit
@testable import TestableDesignExample



class NavigatorSpy: NavigatorContract {
    typealias CallArgs = (viewController: UIViewController, animated: Bool)
    fileprivate(set) var callArgs: [CallArgs] = []

    var reverseNavigator: ReverseNavigatorContract


    init() {
        self.reverseNavigator = ReverseNavigatorStub()
    }


    init(inheriting reverseNavigator: ReverseNavigatorContract) {
        self.reverseNavigator = reverseNavigator
    }


    @discardableResult
    func navigate(to viewController: UIViewController, animated: Bool) -> ReverseNavigatorContract {
        let callArgs = (viewController: viewController, animated: animated)
        self.callArgs.append(callArgs)

        return self.reverseNavigator
    }
}
