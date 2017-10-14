import UIKit
import RxSwift
import RxCocoa



extension RxCocoaInjectable {
    struct InjectableUIScrollView {
        let scrollView: UIScrollView
        let didScroll: ControlEvent<Void>


        static func makeInjectable(of scrollView: UIScrollView) -> InjectableUIScrollView {
            return InjectableUIScrollView(
                scrollView: scrollView,
                didScroll: scrollView.rx.didScroll
            )
        }
    }
}