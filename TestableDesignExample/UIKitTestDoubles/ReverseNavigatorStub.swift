import UIKit
@testable import TestableDesignExample



class ReverseNavigatorStub: ReverseNavigatorContract {
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
