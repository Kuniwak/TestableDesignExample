import UIKit
import XCTest
@testable import TestableDesignExample



struct NavigatorStub: NavigatorContract {
    func navigate(to viewController: UIViewController, animated: Bool) {}
}