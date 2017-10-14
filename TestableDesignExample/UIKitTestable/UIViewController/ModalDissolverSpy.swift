import UIKit
@testable import TestableDesignExample



/**
 A spy class for ModalDissolver.
 This class is useful for capturing calls of `UIViewController#dismiss` for testing.
 */
class ModalDissolverSpy: ModalDissolverProtocol {
    typealias CallArgs = (animated: Bool, completion: (() -> Void)?)


    /**
     Call arguments list for the method `dismiss`.
     You can use the property to test how the method is called.
     */
    fileprivate(set) var callArgs: [CallArgs] = []


    fileprivate let stub: ModalDissolverProtocol


    init() {
        self.stub = ModalDissolverStub()
    }


    init(inheriting stub: ModalDissolverProtocol) {
        self.stub = stub
    }


    func dismiss(animated: Bool) {
        self.stub.dismiss(animated: animated)

        let callArgs: CallArgs = (animated: animated, completion: nil)
        self.callArgs.append(callArgs)
    }


    func dismiss(animated: Bool, completion: (() -> Void)?) {
        self.stub.dismiss(animated: animated, completion: completion)

        let callArgs = (animated: animated, completion: completion)
        self.callArgs.append(callArgs)
    }
}
