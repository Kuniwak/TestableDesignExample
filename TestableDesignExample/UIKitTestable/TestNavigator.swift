import UIKit
import XCTest
@testable import TestableDesignExample



class TestNavigator: NavigatorProtocol {
    private let line: UInt


    init(line: UInt) {
        self.line = line
    }


    func navigate(to viewController: UIViewController, animated: Bool) {
        let window = UIApplication.shared.keyWindow ?? UIWindow()
        window.rootViewController = UINavigationController(
            rootViewController: viewController
        )
        window.makeKeyAndVisible()
    }
}
