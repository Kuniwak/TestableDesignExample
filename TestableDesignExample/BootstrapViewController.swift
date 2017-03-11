import UIKit


class BootstrapViewController: UIViewController {
    static func create() -> UIViewController {
        guard let viewController = R.storyboard.main.bootstrapViewController() else {
            return FatalErrorViewController.create(
                debugInfo: "BootstrapViewController.create returned nil"
            )
        }

        return viewController
    }
}

