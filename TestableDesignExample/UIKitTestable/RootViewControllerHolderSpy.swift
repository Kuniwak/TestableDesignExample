import UIKit
@testable import TestableDesignExample



/**
 A spy class for RootViewControllerHolders.
 This class is useful for capturing assigning `UIWindow.rootViewController` for testing.
 */
class RootViewControllerHolderSpy: RootViewControllerHolderProtocol {
    typealias CallArgs = UIViewController


    /**
     Call arguments list for the method `#back(to rootViewController: UIViewController)`.
     You can use the property to test how the method is called.
     */
    fileprivate(set) var callArgs: [CallArgs] = []

    var stub: RootViewControllerHolderProtocol


    init(inheriting stub: RootViewControllerHolderProtocol) {
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
