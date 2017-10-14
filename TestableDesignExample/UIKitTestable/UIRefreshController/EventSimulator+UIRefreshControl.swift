import UIKit



extension EventSimulator {
    static func simulateBeginRefreshing(on refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        refreshControl.sendActions(for: .valueChanged)
    }
}