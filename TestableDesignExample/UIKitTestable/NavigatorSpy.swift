import UIKit
@testable import TestableDesignExample



/**
 A spy class for Navigator.
 This class is useful for capturing calls of `UINavigationController#pushViewController` for testing.
 */
class NavigatorSpy: NavigatorContract {
    typealias CallArgs = (viewController: UIViewController, animated: Bool)


    /**
     Call arguments list for the method `#navigate(to viewController: UIViewController, animated: Bool)`.
     You can use the property to test how the method is called.
     */
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
