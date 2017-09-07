import UIKit
import XCTest
@testable import TestableDesignExample



struct NavigatorStub: NavigatorContract {
    var reverseNavigator: ReverseNavigatorContract


    init() {
        self.reverseNavigator = ReverseNavigatorStub()
    }


    init(willReturn reverseNavigator: ReverseNavigatorContract) {
        self.reverseNavigator = reverseNavigator
    }


    @discardableResult
    func navigate(to viewController: UIViewController, animated: Bool) -> ReverseNavigatorContract {
        return self.reverseNavigator
    }
}