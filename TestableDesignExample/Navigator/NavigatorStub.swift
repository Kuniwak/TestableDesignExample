import UIKit
import XCTest
@testable import TestableDesignExample



struct NavigatorStub: NavigatorContract {
    private let navigationController: UINavigationController


    init(willPushTo navigationController: UINavigationController) {
        self.navigationController = navigationController
    }


    func navigate(to viewController: UIViewController?) {
        guard let viewController = viewController else {
            print("Warning: Nil UIViewController created")
            return
        }

        self.navigationController.pushViewController(viewController, animated: false)
    }
}