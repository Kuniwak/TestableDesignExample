import UIKit
import XCTest
@testable import TestableDesignExample



class TestNavigator: NavigatorContract {
    private let line: UInt


    init(line: UInt) {
        self.line = line
    }


    func navigate(to viewController: UIViewController) {}


    func navigateWithFallback(to viewController: UIViewController?) {
        guard let viewController = viewController else {
            XCTFail("Unexpected nil ViewController", line: self.line)
            return
        }

        let window = UIApplication.shared.keyWindow!
        window.rootViewController = UINavigationController(
            rootViewController: viewController
        )
    }
}
