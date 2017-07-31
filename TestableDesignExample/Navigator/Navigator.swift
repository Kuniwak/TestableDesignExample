import UIKit



/**
 A protocol for wrapper class of `UINavigationController#pushViewController(_:UIViewController, animated:Bool)`.
 */
protocol NavigatorContract {
    /**
     Push the specified UIViewController to the held UINavigationController.
     */
    func navigate(to viewController: UIViewController, animated: Bool)


    /**
     Push the specified UIViewController to the held UINavigationController.
     This class present an alert when the specified UIViewController is nil.
     */
    func navigateWithFallback(to viewController: UIViewController?, animated: Bool)
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


    /**
     Push the specified UIViewController to the held UINavigationController.
     This class present an alert when the specified UIViewController is nil.
     */
    func navigateWithFallback(to viewController: UIViewController?, animated: Bool) {
        guard let viewController = viewController else {
            self.presentAlert()
            return
        }

        self.navigate(to: viewController, animated: animated)
    }


    private func presentAlert() {
        let alertController = UIAlertController(
            title: "Sorry!",
            message: "Problem occurred when navigating a screen. You can update to fix this problem or contact us.",
            preferredStyle: .alert
        )

        let goBackAction = UIAlertAction(
            title: "Back",
            style: .cancel,
            handler: nil
        )

        alertController.addAction(goBackAction)

        self.navigationController.present(
            alertController,
            animated: true,
            completion: nil
        )
    }
}
