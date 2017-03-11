import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = BootstrapViewController.create()
        self.window = window

        switch BootstrapResourceRegistry.create() {
        case let .success(registry):

            let rootNavigator = RootNavigator(
                willUpdate: window,
                byReading: registry
            )

            rootNavigator.navigateToRoot()

        case let .failure(error):
            window.rootViewController = FatalErrorViewController.create(
                debugInfo: error
            )
        }

        return true
    }
}
