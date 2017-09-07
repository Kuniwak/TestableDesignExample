import UIKit
@testable import TestableDesignExample



class ModalPresenterSpy: ModalPresenterContract {
    typealias CallArgs = (viewController: UIViewController, animated: Bool)
    fileprivate(set) var callArgs: [CallArgs] = []


    func present(viewController: UIViewController, animated: Bool) {
        let callArgs = (viewController: viewController, animated: animated)
        self.callArgs.append(callArgs)
    }
}
