import UIKit



protocol ModalPresenterContract {
    func present(viewController: UIViewController, animated: Bool)
}



class ModalPresenter: ModalPresenterContract {
    private let groundViewController: UIViewController


    init(wherePresentOn groundViewController: UIViewController) {
        self.groundViewController = groundViewController
    }


    func present(viewController: UIViewController, animated: Bool) {
        self.groundViewController.present(viewController, animated: animated)
    }
}
