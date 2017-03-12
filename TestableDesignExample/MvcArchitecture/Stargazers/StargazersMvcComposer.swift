import UIKit



class StargazersMvcComposer: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var progressView: UIProgressView!


    private var registry: BootstrapResourceRegistryContract!
    private var api: GitHubApiClientContract!
    private var navigator: NavigatorContract!
    private var repository: GitHubRepository!
    private var stargazerRepository: StargazerRepositoryContract!

    private var viewMediator: StargazerViewMediatorContract!
    private var controllerMediator: StargazersControllerMediatorContract!


    static func create(
        byStargazersOf repository: GitHubRepository,
        withResourceOf registry: BootstrapResourceRegistryContract,
        andFetchingVia api: GitHubApiClientContract,
        andNavigateBy navigator: NavigatorContract
    ) -> StargazersMvcComposer? {
        return self.create(
            byStargazersOf: repository,
            withResourceOf: registry,
            andFetchingStargazersVia: StargazerRepository(api: api),
            andNavigateBy: navigator,
            andHolding: api
        )
    }


    static func create(
        byStargazersOf repository: GitHubRepository,
        withResourceOf registry: BootstrapResourceRegistryContract,
        andFetchingStargazersVia stargazerRepository: StargazerRepositoryContract,
        andNavigateBy navigator: NavigatorContract,
        andHolding api: GitHubApiClientContract
    ) -> StargazersMvcComposer? {
        guard let viewController = R.storyboard.stargazersScreen.stargazerViewController() else {
            return nil
        }

        viewController.registry = registry
        viewController.api = api
        viewController.stargazerRepository = stargazerRepository
        viewController.navigator = navigator
        viewController.repository = repository

        return viewController
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.repository.text

        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Back",
            style: .done,
            target: nil,
            action: nil
        )

        let refreshControl = UIRefreshControl()
        self.tableView.refreshControl = refreshControl

        let model = StargazerModel(
            for: self.repository,
            fetchingVia: self.stargazerRepository
        )

        self.viewMediator = StargazerViewMediator(
            observing: model,
            andHandling: (
                viewController: self,
                tableView: self.tableView,
                progressView: self.progressView,
                refreshControl: refreshControl
            )
        )

        self.controllerMediator = StargazerControllerMediator(
            willNotifyTo: model,
            from: (
                tableView: self.tableView,
                refreshControl: refreshControl
            ),
            andFindingVisibleRowBy: self.viewMediator,
            andNavigatingBy: self.navigator
        )
    }
}
