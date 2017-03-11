import UIKit



protocol NavigatorContract {
    func navigate(to viewController: UIViewController?)
}



class Navigator: NavigatorContract {
    private let navigationController: UINavigationController


    init (for parentViewController: UINavigationController) {
        self.navigationController = parentViewController
    }


    func navigate(to viewController: UIViewController?) {
        guard let viewController = viewController else {
            self.presentAlert()
            return
        }

        self.navigationController.pushViewController(
            viewController,
            animated: true
        )
    }


    private func presentAlert() {
        let alertController = UIAlertController(
            title: "Problem occurred when ",
            message: "You can update to fix this problem or contact us.",
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
