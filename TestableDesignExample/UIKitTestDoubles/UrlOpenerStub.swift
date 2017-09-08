import UIKit
@testable import TestableDesignExample



/**
 A stub class for UrlOpener.
 This class is useful for ignoring calls of `UIApplication#open` for testing.
 */
class UrlOpenerStub: UrlOpenerContract {
    func open(url: URL) {}
}
