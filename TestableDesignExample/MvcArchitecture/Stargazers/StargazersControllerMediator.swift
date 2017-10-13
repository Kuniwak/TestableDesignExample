import UIKit



protocol StargazersControllerMediatorProtocol {
    func refresh(sender: UIRefreshControl)
}



class StargazerControllerMediator: NSObject, StargazersControllerMediatorProtocol {
    fileprivate let navigator: NavigatorProtocol
    fileprivate let model: StargazerModelProtocol
    fileprivate let viewMediator: StargazerViewMediatorProtocol
    fileprivate let refreshControl: UIRefreshControl
    fileprivate let scrollViewDelegate: UIScrollViewDelegate


    init(
        willNotifyTo model: StargazerModelProtocol,
        from control: (
            tableView: UITableView,
            refreshControl: UIRefreshControl,
            scrollViewDelegate: UIScrollViewDelegate
        ),
        findingVisibleRowBy viewMediator: StargazerViewMediatorProtocol,
        navigatingBy navigator: NavigatorProtocol
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


    @objc func refresh(sender: UIRefreshControl) {
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
        let stargazerViewController = UserMvcComposer(
            representing: UserModel(
                withInitialState: .fetched(
                    result: .success(stargazer)
                )
            )
        )

        self.navigator.navigate(to: stargazerViewController, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
