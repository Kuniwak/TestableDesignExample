import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = BootstrapViewController.create()
        self.window = window

        let rootNavigator = RootNavigator(
            willUpdate: window
        )
        rootNavigator.navigateToRoot()

        return true
    }
}
