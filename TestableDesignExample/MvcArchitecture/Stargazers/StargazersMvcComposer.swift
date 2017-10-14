import UIKit



class StargazersMvcComposer: UIViewController {
    private var gitHubRepository: GitHubRepository
    private var navigator: NavigatorProtocol
    private var model: StargazersModelProtocol
    private var bag: Bag

    private var tableViewDataSource: StargazersTableViewDataSourceProtocol?
    private var navigationViewMediator: StargazersNavigationViewMediatorProtocol?
    private var errorViewMediator: StargazersErrorViewMediatorProtocol?
    private var progressViewMediator: StargazersProgressViewMediatorProtocol?
    private var refreshControlViewMediator: StargazersRefreshViewMediatorProtocol?
    private var refreshController: StargazersRefreshControllerProtocol?
    private var scrollController: StargazersInfiniteScrollControllerProtocol?
    private var tableViewMediator: StargazersTableViewMediatorProtocol?


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

        self.tableViewMediator = StargazersTableViewMediator(
            handling: rootView.tableView
        )

        self.scrollController = StargazersInfiniteScrollController(
            watching: .makeInjectable(of: rootView.tableView),
            determiningBy: InfiniteScrollThresholdTrigger(
                basedOn: PerformanceParameter.stargazersInfiniteScrollThreshold
            ),
            notifying: self.model
        )

        self.navigationViewMediator = StargazersNavigationViewMediator(
            watching: .makeInjectable(of: rootView.tableView),
            findingVisibleRowBy: dataSource,
            navigatingBy: self.navigator
        )

        self.errorViewMediator = StargazersErrorViewMediator(
            observing: self.model,
            presentingAlertBy: ModalPresenter(wherePresentOn: self)
        )

        let refreshControl = UIRefreshControl()
        rootView.tableView.refreshControl = refreshControl

        self.refreshControlViewMediator = StargazersRefreshViewMediator(
            observing: self.model,
            handling: refreshControl
        )

        self.refreshController = StargazersRefreshController(
            watching: .makeInjectable(of: refreshControl),
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
