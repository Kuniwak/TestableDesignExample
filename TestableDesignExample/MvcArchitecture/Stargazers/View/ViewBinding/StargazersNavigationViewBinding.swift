import UIKit
import RxSwift
import RxCocoa



protocol StargazersNavigationViewBindingProtocol {}



class StargazersNavigationViewBinding: StargazersNavigationViewBindingProtocol {
    private let tableViewItemSelected: RxCocoa.Signal<IndexPath>
    private let tableView: UITableView
    private let dataSource: StargazersTableViewDataSourceProtocol
    private let navigator: NavigatorProtocol
    private let bag: Bag
    private let disposeBag = RxSwift.DisposeBag()


    init(
        watching tableViewItemSelected: RxCocoa.Signal<IndexPath>,
        handling tableView: UITableView,
        findingVisibleRowBy dataSource: StargazersTableViewDataSourceProtocol,
        navigatingBy navigator: NavigatorProtocol,
        holding bag: Bag
    ) {
        self.tableViewItemSelected = tableViewItemSelected
        self.tableView = tableView
        self.dataSource = dataSource
        self.navigator = navigator
        self.bag = bag

        self
            .tableViewItemSelected
            .emit(onNext: { [weak self] indexPath in
                guard let this = self else { return }

                this.navigate(by: indexPath)
            })
            .disposed(by: self.disposeBag)
    }


    private func navigate(by indexPath: IndexPath) {
        let stargazer = self.dataSource.visibleStargazers[indexPath.row]
        let stargazerViewController = UserMvcComposer(
            representing: UserModel(
                for: stargazer.id,
                withInitialState: .fetched(
                    result: .success(stargazer)
                ),
                fetchingVia: UserApiRepository(
                    fetchingVia: self.bag.api
                )
            )
        )

        self.navigator.navigate(to: stargazerViewController, animated: true)

        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
