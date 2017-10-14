import UIKit



/**
 A type for wrapper classes that encapsulate an implementation of `UIApplication#open`.
 */
protocol UrlOpenerProtocol {
    /**
     Attempts to open the resource at the specified URL.
     This method behave like `UIApplication#open`.
     */
    func open(url: URL)
}



/**
 A wrapper class to encapsulate a implementation of `UIApplication#open`.
 You can replace the class to the stub or spy for testing.
 */
struct UrlOpener: UrlOpenerProtocol {
    func open(url: URL) {
        if #available (iOS 10.0, *) {
            // NOTE: For iOS 10.0+.
            // https://developer.apple.com/reference/uikit/uiapplication/1648685-open
            UIApplication.shared.open(url)
        }
        else {
            // NOTE: For iOS 2.0–10.0.
            // https://developer.apple.com/reference/uikit/uiapplication/1622961-openurl#parameters
            UIApplication.shared.openURL(url)
        }
    }
}
