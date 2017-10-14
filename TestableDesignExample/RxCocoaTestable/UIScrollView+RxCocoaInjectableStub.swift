import UIKit
import RxSwift
import RxCocoa
@testable import TestableDesignExample



extension RxCocoaInjectable.InjectableUIScrollView {
    static func createStub(
        of scrollView: UIScrollView
    ) -> (injectable: RxCocoaInjectable.InjectableUIScrollView, scroll: () -> Void) {
        let publishSubject = RxSwift.PublishSubject<Void>()
        return (
            injectable: RxCocoaInjectable.InjectableUIScrollView(
                scrollView: scrollView,
                didScroll: ControlEvent<Void>(events: publishSubject)
            ),
            scroll: { publishSubject.onNext(()) }
        )
    }
}