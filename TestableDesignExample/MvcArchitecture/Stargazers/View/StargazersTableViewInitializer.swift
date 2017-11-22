import UIKit



protocol StargazersTableViewInitializerProtocol {}



class StargazersTableViewInitializer: StargazersTableViewInitializerProtocol {
    init(handling tableView: UITableView) {
        tableView.rowHeight = 70
    }
}
