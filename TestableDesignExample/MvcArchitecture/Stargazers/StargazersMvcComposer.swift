import UIKit



class StargazersMvcComposer: UIViewController {
    private var gitHubRepository: GitHubRepository
    private var navigator: NavigatorProtocol
    private var model: StargazerModelProtocol
    private var bag: Bag

    private var viewMediator: StargazerViewMediatorProtocol?
    private var controllerMediator: StargazersControllerMediatorProtocol?


    init(
        for gitHubRepository: GitHubRepository,
        representing model: StargazerModelProtocol,
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

        let refreshControl = UIRefreshControl()
        rootView.tableView.refreshControl = refreshControl

        let viewMediator = StargazerViewMediator(
            observing: self.model,
            handling: (
                tableView: rootView.tableView,
                progressView: rootView.progressView,
                refreshControl: refreshControl
            ),
            presentingModelBy: ModalPresenter(wherePresentOn: self)
        )
        self.viewMediator = viewMediator

        self.controllerMediator = StargazerControllerMediator(
            willNotifyTo: self.model,
            from: (
                tableView: rootView.tableView,
                refreshControl: refreshControl,
                scrollViewDelegate: StargazersInfiniteScrollController(
                    willRequestNextPageVia: self.model
                )
            ),
            findingVisibleRowBy: viewMediator,
            navigatingBy: self.navigator
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
