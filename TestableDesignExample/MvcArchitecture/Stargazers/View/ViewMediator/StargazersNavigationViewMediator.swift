import UIKit
import RxSwift
import RxCocoa



protocol StargazersNavigationViewMediatorProtocol {}



class StargazersNavigationViewMediator: StargazersNavigationViewMediatorProtocol {
    private let navigator: NavigatorProtocol
    private let injectable: RxCocoaInjectable.InjectableUITableView
    private let dataSource: StargazersTableViewDataSourceProtocol
    private let bag: Bag
    private let disposeBag = RxSwift.DisposeBag()


    init(
        watching injectable: RxCocoaInjectable.InjectableUITableView,
        findingVisibleRowBy dataSource: StargazersTableViewDataSourceProtocol,
        navigatingBy navigator: NavigatorProtocol,
        holding bag: Bag
    ) {
        self.navigator = navigator
        self.injectable = injectable
        self.dataSource = dataSource
        self.bag = bag

        self.injectable
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

        self.injectable.tableView.deselectRow(at: indexPath, animated: true)
    }
}
