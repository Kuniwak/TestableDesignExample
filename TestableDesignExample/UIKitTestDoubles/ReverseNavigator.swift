import UIKit



/**
 A type for wrapper classes of `UINavigationController#(_:UIViewController, animated:Bool)`.
 */
protocol ReverseNavigatorContract {
    /**
     Pushes a view controller onto the receiver’s stack and updates the display.
     This method behave like `UINavigationController#popToViewController(UIVIewController, animated: Bool)`

     - throws: ReverseNavigatorError will be thrown when the UIViewController is not in the navigation stack.
     */
    func back(animated: Bool) throws
}



/**
 A type for errors that can be thrown when `UINavigationController#popToViewController(UIVIewController, animated: Bool)`.
 */
enum ReverseNavigatorError: Error {
    case noDestinationViewControllerInNavigationStack
}



/**
 A wrapper class to encapsulate a implementation of `UINavigationController#popToViewController(UIViewController, animated: Bool)`.
 You can replace the class to the stub or spy for testing.
 */
class ReverseNavigator: ReverseNavigatorContract {
    private let navigationController: UINavigationController
    private let viewController: UIViewController


    /**
     Return newly initialized Navigator for the specified UINavigationController.
     You can pop to the UIViewController by calling the method `#back`.
     */
    init(willPopTo viewController: UIViewController, on navigationController: UINavigationController) {
        self.viewController = viewController
        self.navigationController = navigationController
    }


    func back(animated: Bool) throws {
        guard self.navigationController.viewControllers.contains(self.viewController) else {
            throw ReverseNavigatorError.noDestinationViewControllerInNavigationStack
        }

        self.navigationController.popToViewController(
            self.viewController,
            animated: animated
        )
    }
}
