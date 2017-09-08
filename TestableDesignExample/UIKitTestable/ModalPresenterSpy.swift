import UIKit
@testable import TestableDesignExample



/**
 A spy class for ModalPresenters.
 This class is useful for capturing calls of `UIViewController#present` for testing.
 */
class ModalPresenterSpy: ModalPresenterContract {
    typealias CallArgs = (viewController: UIViewController, animated: Bool, completion: (() -> Void)?)


    /**
     Call arguments list for the method `present`.
     You can use the property to test how the method is called.
     */
    fileprivate(set) var callArgs: [CallArgs] = []

    var stub: ModalPresenterContract


    init(inheriting stub: ModalPresenterContract) {
        self.stub = stub
    }


    func present(viewController: UIViewController, animated: Bool) {
        self.stub.present(viewController: viewController, animated: animated)

        let callArgs: CallArgs = (viewController: viewController, animated: animated, completion: nil)
        self.callArgs.append(callArgs)
    }


    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        self.stub.present(viewController: viewController, animated: animated, completion: completion)

        let callArgs: CallArgs = (viewController: viewController, animated: animated, completion: completion)
        self.callArgs.append(callArgs)
    }
}
