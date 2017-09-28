import UIKit
@testable import TestableDesignExample



/**
 A spy class for GlobalModalPresenter.
 This class is useful for capturing calls of `GlobalModalPresenter#present` for testing.
 */
class GlobalModalPresenterSpy: GlobalModalPresenterContract {
    typealias CallArgs = (viewController: UIViewController, animated: Bool, completion: (() -> Void)?)


    /**
     Call arguments list for the method `GlobalModalPresenter#present`.
     You can use the property to test how the method is called.
     */
    private(set) var callArgs: [CallArgs] = []


    var stub: GlobalModalPresenterContract


    var dissolver: ModalDissolverContract {
        return self.stub.dissolver
    }


    init(inherit stub: GlobalModalPresenterContract) {
        self.stub = stub
    }


    func present(
        viewController: UIViewController,
        animated: Bool
    ) {
        self.present(
            viewController: viewController,
            animated: animated,
            completion: nil
        )
    }


    func present(
        viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        self.callArgs.append((
            viewController: viewController,
            animated: animated,
            completion: completion
        ))

        self.stub.present(
            viewController: viewController,
            animated: animated,
            completion: completion
        )
    }
}
