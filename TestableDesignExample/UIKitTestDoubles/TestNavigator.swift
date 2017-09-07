import UIKit
import XCTest
@testable import TestableDesignExample



class TestNavigator: NavigatorContract {
    private let line: UInt
    var reverseNavigator: ReverseNavigatorContract


    init(willReturn reverseNavigator: ReverseNavigatorContract, line: UInt) {
        self.reverseNavigator = reverseNavigator
        self.line = line
    }


    init(line: UInt) {
        self.reverseNavigator = ReverseNavigatorStub()
        self.line = line
    }


    @discardableResult
    func navigate(to viewController: UIViewController, animated: Bool) -> ReverseNavigatorContract {
        let window = UIApplication.shared.keyWindow!
        window.rootViewController = UINavigationController(
            rootViewController: viewController
        )

        return self.reverseNavigator
    }
}
