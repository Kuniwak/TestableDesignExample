import UIKit



extension EventSimulator {
    static func simulateSelect(on tableView: UITableView, at indexPath: IndexPath) {
        guard let tableViewDelegate = tableView.delegate else {
            return
        }

        tableViewDelegate.tableView?(
            tableView,
            didSelectRowAt: indexPath
        )
    }
}