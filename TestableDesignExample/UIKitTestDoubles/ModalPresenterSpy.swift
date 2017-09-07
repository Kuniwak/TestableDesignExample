import UIKit
@testable import TestableDesignExample



class ModalPresenterSpy: ModalPresenterContract {
    typealias CallArgs = (viewController: UIViewController, animated: Bool)
    fileprivate(set) var callArgs: [CallArgs] = []


    @discardableResult
    func present(viewController: UIViewController, animated: Bool) -> ModalDissolverContract {
        let callArgs = (viewController: viewController, animated: animated)
        self.callArgs.append(callArgs)

        return ModalDissolverStub()
    }
}
