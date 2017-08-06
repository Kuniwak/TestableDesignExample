import UIKit



protocol StargazersControllerMediatorContract {
    func refresh(sender: UIRefreshControl)
}



class StargazerControllerMediator: NSObject, StargazersControllerMediatorContract {
    fileprivate let navigator: NavigatorContract
    fileprivate let model: StargazerModelContract
    fileprivate let viewMediator: StargazerViewMediatorContract
    fileprivate let refreshControl: UIRefreshControl
    fileprivate let scrollViewDelegate: UIScrollViewDelegate


    init(
        willNotifyTo model: StargazerModelContract,
        from control: (
            tableView: UITableView,
            refreshControl: UIRefreshControl,
            scrollViewDelegate: UIScrollViewDelegate
        ),
        findingVisibleRowBy viewMediator: StargazerViewMediatorContract,
        navigatingBy navigator: NavigatorContract
    ) {
        self.model = model
        self.viewMediator = viewMediator
        self.navigator = navigator
        self.refreshControl = control.refreshControl
        self.scrollViewDelegate = control.scrollViewDelegate

        super.init()

        control.tableView.delegate = self
        control.refreshControl.addTarget(
            self,
            action: #selector(StargazerControllerMediator.refresh(sender:)),
            for: .valueChanged
        )
    }


    func refresh(sender: UIRefreshControl) {
        self.model.clear()
        self.model.fetchNext()
    }
}



extension StargazerControllerMediator: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollViewDelegate.scrollViewDidScroll?(scrollView)
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stargazer = self.viewMediator.visibleStargazers[indexPath.row]
        let stargazerViewController = UserMvcComposer.create(
            byModel: UserModel(
                withInitialState: .fetched(
                    result: .success(stargazer)
                )
            )
        )

        self.navigator.navigateWithFallback(to: stargazerViewController, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
