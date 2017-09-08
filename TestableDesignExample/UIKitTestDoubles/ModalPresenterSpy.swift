import UIKit
@testable import TestableDesignExample



/**
 A spy class for ModalPresenters.
 This class is useful for capturing calls of `UIViewController#present` for testing.
 */
class ModalPresenterSpy: ModalPresenterContract {
    typealias CallArgs = (viewController: UIViewController, animated: Bool)


    /**
     Call arguments list for the method `present`.
     You can use the property to test how the method is called.
     */
    fileprivate(set) var callArgs: [CallArgs] = []


    @discardableResult
    func present(viewController: UIViewController, animated: Bool) -> ModalDissolverContract {
        let callArgs = (viewController: viewController, animated: animated)
        self.callArgs.append(callArgs)

        return ModalDissolverStub()
    }
}
