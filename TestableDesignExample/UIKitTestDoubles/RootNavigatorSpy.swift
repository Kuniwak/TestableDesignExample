import UIKit
@testable import TestableDesignExample



class RootNavigatorSpy: RootNavigatorContract {
    fileprivate(set) var callArgs = [Void]()


    func navigateToRoot() {
        self.callArgs.append(())
    }
}
