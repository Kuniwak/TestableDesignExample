import UIKit
@testable import TestableDesignExample



/**
 A spy class for UrlOpener.
 This class is useful for capturing calls of `UIApplication#open` for testing.
 */
class UrlOpenerSpy: UrlOpenerContract {
    /**
     Call arguments list for the method `#open(url: URL)`.
     You can use the property to test how the method is called.
     */
    fileprivate(set) var callArgs = [URL]()


    func open(url: URL) {
        self.callArgs.append(url)
    }
}
