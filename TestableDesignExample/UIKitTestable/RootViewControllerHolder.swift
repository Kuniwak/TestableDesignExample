import UIKit



/**
 A type for wrapper class of `UIWindow.rootViewController`.
 */
protocol RootViewControllerHolderProtocol {
    /**
     Replace the root UIViewController of UIWindow to the specified one.
     */
    func alter(to rootViewController: UIViewController)
}



/**
 A wrapper class to encapsulate a implementation of assigning `UIWindow.rootViewController`.
 You can replace the class to the stub or spy for testing.
 */
class RootViewControllerHolder: RootViewControllerHolderProtocol {
    private let window: UIWindow


    /**
     Return newly initialized RootViewControllerHolder for the specified UIWindow.
     You can replace the root UIViewController of the window by calling `#alter`
     */
    init(whoHaveViewController window: UIWindow) {
        self.window = window
    }


    func alter(to rootViewController: UIViewController) {
        self.window.rootViewController = rootViewController
    }
}
