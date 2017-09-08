import UIKit
@testable import TestableDesignExample



/**
 A stub class for RootViewControllerHolders.
 This class is useful for ignoring assigning `UIWindow.rootViewController` for testing.
 */
class RootViewControllerHolderStub: RootViewControllerHolderContract {
    func alter(to rootViewController: UIViewController) {}
}
