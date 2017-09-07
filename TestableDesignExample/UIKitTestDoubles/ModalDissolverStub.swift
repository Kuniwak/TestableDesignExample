import UIKit
@testable import TestableDesignExample



class ModalDissolverStub: ModalDissolverContract {
    func dismiss(animated: Bool) {}
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        guard let completion = completion else { return }
        completion()
    }
}
