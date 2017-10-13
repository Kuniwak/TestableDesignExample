import UIKit
import RxSwift
import RxCocoa



protocol StargazersNavigationViewMediatorProtocol {}



class StargazersNavigationViewMediator: StargazersNavigationViewMediatorProtocol {
    private let navigator: NavigatorProtocol
    private let tableView: UITableView
    private let dataSource: StargazersTableViewDataSourceProtocol
    private let disposeBag = RxSwift.DisposeBag()


    init(
        watching tableView: UITableView,
        findingVisibleRowBy dataSource: StargazersTableViewDataSourceProtocol,
        navigatingBy navigator: NavigatorProtocol
    ) {
        self.navigator = navigator
        self.tableView = tableView
        self.dataSource = dataSource

        tableView.rx
            .itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let this = self else { return }

                this.navigate(by: indexPath)
            })
            .disposed(by: self.disposeBag)
    }


    private func navigate(by indexPath: IndexPath) {
        let stargazer = self.dataSource.visibleStargazers[indexPath.row]
        let stargazerViewController = UserMvcComposer(
            representing: UserModel(
                withInitialState: .fetched(
                    result: .success(stargazer)
                )
            )
        )

        self.navigator.navigate(to: stargazerViewController, animated: true)

        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
