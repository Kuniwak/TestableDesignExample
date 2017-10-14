import UIKit
import RxSwift
import RxCocoa



extension RxCocoaInjectable {
    struct InjectableUITableView {
        let tableView: UITableView
        let itemSelected: RxCocoa.ControlEvent<IndexPath>


        static func makeInjectable(
            of tableView: UITableView
        ) -> InjectableUITableView {
            return InjectableUITableView(
                tableView: tableView,
                itemSelected: tableView.rx.itemSelected
            )
        }
    }
}
