import UIKit



protocol ReverseNavigatorContract {
    func back(animated: Bool) throws
}



enum ReverseNavigatorError: Error {
    case noDestinationViewControllerInNavigationStack
}



class ReverseNavigator: ReverseNavigatorContract {
    private let navigationController: UINavigationController
    private let viewController: UIViewController


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
