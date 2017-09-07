import UIKit
@testable import TestableDesignExample



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
