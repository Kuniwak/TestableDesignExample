import UIKit
import RxSwift
import RxCocoa



extension RxCocoaInjectable {
    struct InjectableUIRefreshControl {
        let refreshControl: UIRefreshControl
        let valueChanged: RxCocoa.ControlEvent<Void>


        static func makeInjectable(
            of refreshControl: UIRefreshControl
        ) -> InjectableUIRefreshControl {
            return InjectableUIRefreshControl(
                refreshControl: refreshControl,
                valueChanged: refreshControl.rx.controlEvent(.valueChanged)
            )
        }
    }
}