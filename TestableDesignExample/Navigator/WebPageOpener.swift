import UIKit



protocol WebPageOpenerContract {
    func open(urlOnSafari url: URL)
}



struct WebPageOpener: WebPageOpenerContract {
    func open(urlOnSafari url: URL) {
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
