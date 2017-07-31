import UIKit



protocol LifterContract {
    func present(viewController: UIViewController, animated: Bool)
    func presentWithFallback(viewController: UIViewController?, animated: Bool)
}



class Lifter: LifterContract {
    private let groundViewController: UIViewController


    init(wherePresentOn groundViewController: UIViewController) {
        self.groundViewController = groundViewController
    }


    func present(viewController: UIViewController, animated: Bool) {
        self.groundViewController.present(viewController, animated: animated)
    }


    func presentWithFallback(viewController: UIViewController?, animated: Bool) {
        guard let viewController = viewController else {
            self.presentAlert()
            return
        }

        self.present(viewController: viewController, animated: animated)
    }



    private func presentAlert() {
        let alertController = UIAlertController(
            title: "Sorry!",
            message: "Problem occurred when presenting a screen. You can update to fix this problem or contact us.",
            preferredStyle: .alert
        )

        let goBackAction = UIAlertAction(
            title: "Back",
            style: .cancel,
            handler: nil
        )

        alertController.addAction(goBackAction)

        self.groundViewController.present(
            alertController,
            animated: true,
            completion: nil
        )
    }
}
