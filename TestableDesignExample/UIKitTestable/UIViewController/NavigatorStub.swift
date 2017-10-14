import UIKit
@testable import TestableDesignExample



/**
 A stub class for Navigator.
 This class is useful for ignoring calls of `UINavigationController#pushViewController` for testing.
 */
struct NavigatorStub: NavigatorProtocol {
    func navigate(to viewController: UIViewController, animated: Bool) {}
}