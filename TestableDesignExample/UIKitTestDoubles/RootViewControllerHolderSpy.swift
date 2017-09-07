import UIKit
@testable import TestableDesignExample



class RootViewControllerHolderSpy: RootViewControllerHolderContract {
    typealias CallArgs = UIViewController
    fileprivate(set) var callArgs: [CallArgs] = []

    var stub: RootViewControllerHolderContract


    init(inheriting stub: RootViewControllerHolderContract) {
        self.stub = stub
    }


    init() {
        self.stub = RootViewControllerHolderStub()
    }


    func alter(to rootViewController: UIViewController) -> UIViewController? {
        let result = self.stub.alter(to: rootViewController)

        self.callArgs.append(rootViewController)

        return result
    }
}
