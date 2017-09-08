import UIKit
@testable import TestableDesignExample



/**
 A spy class for RootViewControllerHolders.
 This class is useful for capturing assigning `UIWindow.rootViewController` for testing.
 */
class RootViewControllerHolderSpy: RootViewControllerHolderContract {
    typealias CallArgs = UIViewController


    /**
     Call arguments list for the method `#back(to rootViewController: UIViewController)`.
     You can use the property to test how the method is called.
     */
    fileprivate(set) var callArgs: [CallArgs] = []

    var stub: RootViewControllerHolderContract


    init(inheriting stub: RootViewControllerHolderContract) {
        self.stub = stub
    }


    init() {
        self.stub = RootViewControllerHolderStub()
    }


    func alter(to rootViewController: UIViewController) {
        self.stub.alter(to: rootViewController)
        self.callArgs.append(rootViewController)
    }
}
