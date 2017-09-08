import UIKit
@testable import TestableDesignExample



/**
 A stub class for RootViewControllerHolders.
 This class is useful for ignoring assigning `UIWindow.rootViewController` for testing.
 */
class RootViewControllerHolderStub: RootViewControllerHolderContract {
    var rootViewController: UIViewController?


    init(willReturn rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }


    init() {
        self.rootViewController = nil
    }


    @discardableResult
    func alter(to rootViewController: UIViewController) -> UIViewController? {
        return self.rootViewController
    }
}
