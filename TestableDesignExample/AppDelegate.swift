import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    fileprivate var rootViewControllerHolder: RootViewControllerHolder?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = application.keyWindow ?? UIWindow()
        window.makeKeyAndVisible()

        let rootViewControllerHolder = RootViewControllerHolder(
            whoHaveViewController: window
        )
        self.rootViewControllerHolder = rootViewControllerHolder

        let rootNavigator = RootNavigator(
            using: rootViewControllerHolder
        )
        rootNavigator.navigateToRoot()

        return true
    }
}
