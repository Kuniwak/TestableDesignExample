import UIKit


protocol StargazersControllerMediatorContract {
    func refresh(sender: UIRefreshControl)
}




class StargazerControllerMediator: NSObject, StargazersControllerMediatorContract {
    fileprivate let navigator: NavigatorContract
    fileprivate let model: StargazerModelContract
    fileprivate let viewMediator: StargazerViewMediatorContract
    fileprivate let refreshControl: UIRefreshControl


    init(
        willNotifyTo model: StargazerModelContract,
        from control: (
            tableView: UITableView,
            refreshControl: UIRefreshControl
        ),
        andFindingVisibleRowBy viewMediator: StargazerViewMediatorContract,
        andNavigatingBy navigator: NavigatorContract
    ) {
        self.model = model
        self.viewMediator = viewMediator
        self.navigator = navigator
        self.refreshControl = control.refreshControl

        super.init()

        control.tableView.delegate = self
        control.refreshControl.addTarget(
            self,
            action: #selector(StargazerControllerMediator.refresh(sender:)),
            for: .valueChanged
        )
    }


    func refresh(sender: UIRefreshControl) {
        self.model.fetch()
    }
}



extension StargazerControllerMediator: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stargazer = self.viewMediator.visibleStargazers[indexPath.row]
        let stargazerViewController = UserMvcComposer.create(
            for: stargazer
        )

        self.navigator.navigateWithFallback(to: stargazerViewController)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
