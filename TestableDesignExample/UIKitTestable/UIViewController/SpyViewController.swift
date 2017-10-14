import UIKit



/**
 A spy class for UIViewController.
 This class is useful for capturing calls of life-cycle event handlers.
 */
class SpyViewController: UIViewController {
    enum CallArgs: Equatable {
        case viewDidDisappear(animated: Bool)
        case viewDidAppear(animated: Bool)


        static func ==(lhs: CallArgs, rhs: CallArgs) -> Bool {
            switch (lhs, rhs) {
            case let (.viewDidAppear(animated: l), .viewDidAppear(animated: r)):
                return l == r
            case let (.viewDidDisappear(animated: l), .viewDidDisappear(animated: r)):
                return l == r
            default:
                return false
            }
        }
    }


    /**
     Call arguments list for the life-cycle event handlers.
     You can use the property to test how the method is called.
     */
    fileprivate(set) var callArgs: [CallArgs] = []


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.callArgs.append(.viewDidAppear(animated: animated))
    }


    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.callArgs.append(.viewDidDisappear(animated: animated))
    }
}
