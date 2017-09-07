import UIKit
@testable import TestableDesignExample



class ModalDissolverSpy: ModalDissolverContract {
    typealias CallArgs = (animated: Bool, completion: (() -> Void)?)
    fileprivate(set) var callArgs: [CallArgs] = []

    fileprivate let stub = ModalDissolverStub()


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
