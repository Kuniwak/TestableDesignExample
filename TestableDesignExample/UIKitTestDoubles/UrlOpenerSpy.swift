import UIKit
@testable import TestableDesignExample



class UrlOpenerSpy: UrlOpenerContract {
    fileprivate(set) var callArgs = [URL]()


    func open(url: URL) {
        self.callArgs.append(url)
    }
}
