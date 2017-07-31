import UIKit



enum VisualDecorator {
    static func decorate(navigationBar: UINavigationBar) {
        navigationBar.barStyle = .black
        navigationBar.isTranslucent = false
        navigationBar.backgroundColor = ColorCatalog.Accent.background
        navigationBar.barTintColor = ColorCatalog.Accent.background

        navigationBar.tintColor = ColorCatalog.Accent.font
        navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: ColorCatalog.Accent.font,
        ]
    }
}