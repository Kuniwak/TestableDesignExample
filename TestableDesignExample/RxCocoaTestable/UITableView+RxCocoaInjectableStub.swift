import UIKit
import RxSwift
import RxCocoa
@testable import TestableDesignExample



extension RxCocoaInjectable.InjectableUITableView {
    static func createStub(
        of tableView: UITableView
    ) -> (injectable: RxCocoaInjectable.InjectableUITableView, selectItem: (IndexPath) -> Void) {
        let publishSubject = RxSwift.PublishSubject<IndexPath>()
        return (
            injectable: RxCocoaInjectable.InjectableUITableView(
                tableView: tableView,
                itemSelected: ControlEvent<IndexPath>(events: publishSubject)
            ),
            selectItem: { publishSubject.onNext($0) }
        )
    }
}
