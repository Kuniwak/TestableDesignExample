import UIKit



struct ColorCatalog {
    struct Accent {
        static let font = UIColor(hue: 0 / 360, saturation: 0 / 100, brightness: 100 / 100, alpha: 0.75)
        static let background = UIColor(hue: 210 / 360, saturation: 21.7 / 100, brightness: 18 / 100, alpha: 0)
    }


    struct Weak {
        static let font = UIColor(hue: 211.8 / 360, saturation: 16.2 / 100, brightness: 41.2 / 100, alpha: 0)
        static let background = UIColor(hue: 210 / 360, saturation: 0.8 / 100, brightness: 98.8 / 100, alpha: 0)
    }


    struct Default {
        static let font = UIColor(hue: 210 / 360, saturation: 21.7 / 100, brightness: 18 / 100, alpha: 0)
        static let background = UIColor.white
    }
}