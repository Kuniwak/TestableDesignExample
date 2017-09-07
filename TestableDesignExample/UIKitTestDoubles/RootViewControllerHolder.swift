import UIKit



protocol RootViewControllerHolderContract {
    @discardableResult
    func alter(to rootViewController: UIViewController) -> UIViewController?
}



class ViewControllerViewHolder: RootViewControllerHolderContract {
    private let window: UIWindow


    init(whoHaveViewController window: UIWindow) {
        self.window = window
    }


    @discardableResult
    func alter(to rootViewController: UIViewController) -> UIViewController? {
        let previousRootViewController = self.window.rootViewController

        self.window.rootViewController = rootViewController

        return previousRootViewController
    }
}
