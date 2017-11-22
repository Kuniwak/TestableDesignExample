import UIKit
import RxSwift
import RxCocoa



class StargazersMvcComposer: UIViewController {
    private var gitHubRepository: GitHubRepository
    private var navigator: NavigatorProtocol
    private var model: StargazersModelProtocol
    private var bag: Bag

    private var tableViewDataSource: StargazersTableViewDataSourceProtocol?
    private var navigationViewBinding: StargazersNavigationViewBindingProtocol?
    private var errorViewBinding: StargazersErrorViewBindingProtocol?
    private var progressViewBinding: StargazersProgressViewBindingProtocol?
    private var refreshControlViewBinding: StargazersRefreshViewBindingProtocol?
    private var refreshController: StargazersRefreshControllerProtocol?
    private var scrollController: StargazersInfiniteScrollControllerProtocol?
    private var tableViewBinding: StargazersTableViewInitializerProtocol?


    init(
        for gitHubRepository: GitHubRepository,
        representing model: StargazersModelProtocol,
        navigatingBy navigator: NavigatorProtocol,
        holding bag: Bag
    ) {
        self.gitHubRepository = gitHubRepository
        self.model = model
        self.navigator = navigator
        self.bag = bag

        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder aDecoder: NSCoder) {
        return nil
    }


    override func loadView() {
        let rootView = StargazersScreenRootView()
        self.view = rootView

        let dataSource = StargazersTableViewDataSource(
            observing: self.model,
            handling: rootView.tableView
        )
        self.tableViewDataSource = dataSource
        rootView.tableView.dataSource = dataSource

        self.tableViewBinding = StargazersTableViewInitializer(
            handling: rootView.tableView
        )

        self.scrollController = StargazersInfiniteScrollController(
            watching: rootView.tableView.rx.didScroll.asSignal(),
            handling: rootView.tableView,
            determiningBy: InfiniteScrollThresholdTrigger(
                basedOn: PerformanceParameter.stargazersInfiniteScrollThreshold
            ),
            notifying: self.model
        )

        self.navigationViewBinding = StargazersNavigationViewBinding(
            watching: rootView.tableView.rx.itemSelected.asSignal(),
            handling: rootView.tableView,
            findingVisibleRowBy: dataSource,
            navigatingBy: self.navigator,
            holding: self.bag
        )

        self.errorViewBinding = StargazersErrorViewBinding(
            observing: self.model,
            presentingAlertBy: ModalPresenter(wherePresentOn: self)
        )

        let refreshControl = UIRefreshControl()
        rootView.tableView.refreshControl = refreshControl

        self.refreshControlViewBinding = StargazersRefreshViewBinding(
            observing: self.model,
            handling: refreshControl
        )

        self.refreshController = StargazersRefreshController(
            watching: refreshControl.rx.controlEvent(.valueChanged).asSignal(),
            notifying: self.model
        )
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.gitHubRepository.text

        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Back",
            style: .done,
            target: nil,
            action: nil
        )

        self.model.fetchNext()
    }
}
