import UIKit



protocol StargazersTableViewMediatorProtocol {}



class StargazersTableViewMediator: StargazersTableViewMediatorProtocol {
    init(handling tableView: UITableView) {
        tableView.rowHeight = 70
    }
}
