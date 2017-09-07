import UIKit



/**
 A protocol for wrapper class of `UINavigationController#pushViewController(_:UIViewController, animated:Bool)`.
 */
protocol NavigatorContract {
    /**
     Push the specified UIViewController to the held UINavigationController.
     */
    func navigate(to viewController: UIViewController, animated: Bool)
}



class Navigator: NavigatorContract {
    private let navigationController: UINavigationController


    init (for navigationController: UINavigationController) {
        self.navigationController = navigationController
    }


    /**
     Push the specified UIViewController to the held UINavigationController.
     */
    func navigate(to viewController: UIViewController, animated: Bool) {
        self.navigationController.pushViewController(
            viewController,
            animated: animated
        )
    }
}
