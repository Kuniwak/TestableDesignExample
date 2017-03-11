import UIKit



class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.barStyle = .black
        self.navigationBar.isTranslucent = false
        self.navigationBar.backgroundColor = ColorCatalog.Accent.background
        self.navigationBar.barTintColor = ColorCatalog.Accent.background

        self.navigationBar.tintColor = ColorCatalog.Accent.font
        self.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: ColorCatalog.Accent.font,
        ]
    }
}