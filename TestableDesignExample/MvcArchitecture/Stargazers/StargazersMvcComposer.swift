import UIKit



class StargazersMvcComposer: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var progressView: UIProgressView!


    private var gitHubRepository: GitHubRepository!
    private var navigator: NavigatorContract!
    private var model: StargazerModelContract!
    private var bag: Bag!


    static func create(
        byStargazersOf gitHubRepository: GitHubRepository,
        presenting model: StargazerModelContract,
        navigatingBy navigator: NavigatorContract,
        holding bag: Bag
    ) -> StargazersMvcComposer? {
        guard let viewController = R.storyboard.stargazersScreen.stargazerViewController() else {
            return nil
        }

        viewController.gitHubRepository = gitHubRepository
        viewController.model = model
        viewController.navigator = navigator
        viewController.bag = bag

        return viewController
    }


    private var viewMediator: StargazerViewMediatorContract!
    private var controllerMediator: StargazersControllerMediatorContract!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.gitHubRepository.text

        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Back",
            style: .done,
            target: nil,
            action: nil
        )

        let refreshControl = UIRefreshControl()
        self.tableView.refreshControl = refreshControl

        self.viewMediator = StargazerViewMediator(
            observing: self.model,
            andHandling: (
                viewController: self,
                tableView: self.tableView,
                progressView: self.progressView,
                refreshControl: refreshControl
            )
        )

        self.controllerMediator = StargazerControllerMediator(
            willNotifyTo: self.model,
            from: (
                tableView: self.tableView,
                refreshControl: refreshControl
            ),
            andFindingVisibleRowBy: self.viewMediator,
            andNavigatingBy: self.navigator
        )
    }
}
