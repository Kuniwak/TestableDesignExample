import UIKit
@testable import TestableDesignExample



/**
 A spy class for ReverseNavigators.
 This class is useful for ignoring calls of `UINavigationController#popToViewController` for testing.
 */
class ReverseNavigatorStub: ReverseNavigatorProtocol {
    var error: ReverseNavigatorError?


    init() {
        self.error = nil
    }


    init(willThrow error: ReverseNavigatorError) {
        self.error = error
    }


    func back(animated: Bool) throws {
        guard let error = error else {
            return
        }

        throw error
    }
}
