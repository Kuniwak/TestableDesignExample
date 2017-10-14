import UIKit
import RxSwift
import RxCocoa
@testable import TestableDesignExample



extension RxCocoaInjectable.InjectableUIRefreshControl {
    static func createStub(
        of refreshControl: UIRefreshControl
    ) -> (injectable: RxCocoaInjectable.InjectableUIRefreshControl, refresh: () -> Void) {
        let publishSubject = RxSwift.PublishSubject<Void>()

        return (
            injectable: RxCocoaInjectable.InjectableUIRefreshControl(
                refreshControl: refreshControl,
                valueChanged: ControlEvent<Void>(events: publishSubject)
            ),
            refresh: { publishSubject.onNext(()) }
        )
    }
}