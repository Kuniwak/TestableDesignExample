import UIKit



/**
 A type for wrapper classes of `UINavigationController#pushViewController(_:UIViewController, animated:Bool)`.
 */
protocol NavigatorContract {
    /**
     Pushes a view controller onto the receiver’s stack and updates the display.
     This method behave like `UINavigationController#pushViewController(UIViewController, animated: Bool)`
     */
    @discardableResult
    func navigate(to viewController: UIViewController, animated: Bool) -> ReverseNavigatorContract
}



/**
 A wrapper class to encapsulate a implementation of `UINavigationController#pushViewController(UIViewController, animated: Bool)`.
 You can replace the class to the stub or spy for testing.
 */
class Navigator: NavigatorContract {
    private let navigationController: UINavigationController


    /**
     Return newly initialized Navigator for the specified UINavigationController.
     You can push to the UINavigationController by calling the method `#navigate`.
     */
    init (for navigationController: UINavigationController) {
        self.navigationController = navigationController
    }


    @discardableResult
    func navigate(to viewController: UIViewController, animated: Bool) -> ReverseNavigatorContract {
        self.navigationController.pushViewController(
            viewController,
            animated: animated
        )

        return ReverseNavigator(
            willPopTo: viewController,
            on: self.navigationController
        )
    }
}
