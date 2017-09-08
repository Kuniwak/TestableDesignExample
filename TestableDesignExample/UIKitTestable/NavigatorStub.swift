import UIKit
import XCTest
@testable import TestableDesignExample



/**
 A stub class for Navigator.
 This class is useful for ignoring calls of `UINavigationController#pushViewController` for testing.
 */
struct NavigatorStub: NavigatorContract {
    var reverseNavigator: ReverseNavigatorContract


    init() {
        self.reverseNavigator = ReverseNavigatorStub()
    }


    init(willReturn reverseNavigator: ReverseNavigatorContract) {
        self.reverseNavigator = reverseNavigator
    }


    @discardableResult
    func navigate(to viewController: UIViewController, animated: Bool) -> ReverseNavigatorContract {
        return self.reverseNavigator
    }
}