import UIKit
import RxSwift



protocol StargazerViewMediatorContract: class {
    var visibleStargazers: [GitHubUser] { get }

    func reload()
    func present(error: StargazerModelError)
    func presentLoadingState()
    func presentCompleteState()
}



class StargazerViewMediator: StargazerViewMediatorContract {
    private let dataSource: DataSource
    private let model: StargazerModelContract
    private weak var viewController: UIViewController?
    private let tableView: UITableView
    private weak var progressView: UIProgressView?
    private let refreshControl: UIRefreshControl


    var visibleStargazers: [GitHubUser] {
        return self.dataSource.stargazers
    }



    init(
        observing model: StargazerModelContract,
        andHandling handle: (
            viewController: UIViewController,
            tableView: UITableView,
            progressView: UIProgressView,
            refreshControl: UIRefreshControl
        )
    ) {
        self.model = model
        self.viewController = handle.viewController
        self.tableView = handle.tableView
        self.progressView = handle.progressView
        self.refreshControl = handle.refreshControl

        let token = StargazerCell.register(to: handle.tableView)
        self.dataSource = DataSource(
            observing: model,
            andMustHave: token
        )

        self.dataSource.mediator = self
        self.tableView.dataSource = self.dataSource
    }


    private func decorate() {
        self.refreshControl.backgroundColor = ColorCatalog.Weak.font
        self.refreshControl.isOpaque = true
    }



    func reload() {
        self.tableView.reloadData()
    }



    func presentCompleteState() {
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
        else {
            self.progressView?.setProgress(1.0, animated: true)
            self.progressView?.isHidden = true
        }
    }



    func presentLoadingState() {
        if !self.refreshControl.isRefreshing {
            // NOTE: Fake progress X-D
            self.progressView?.isHidden = false
            self.progressView?.setProgress(0.8, animated: true)
        }
    }



    func present(error: StargazerModelError) {
        dump(error)

        let alertController = UIAlertController(
            title: "Error",
            message: "\(error)",
            preferredStyle: .alert
        )

        let goingBackAction = UIAlertAction(
            title: "Back",
            style: .cancel
        )

        alertController.addAction(goingBackAction)
        alertController.preferredAction = goingBackAction

        self.viewController?.present(alertController, animated: true)
    }




    class DataSource: NSObject, UITableViewDataSource {
        private let token: StargazerCell.RegistrationToken
        private let model: StargazerModelContract
        private let disposeBag = RxSwift.DisposeBag()
        private(set) var stargazers = [GitHubUser]()
        weak var mediator: StargazerViewMediatorContract?


        init(
            observing model: StargazerModelContract,
            andMustHave token: StargazerCell.RegistrationToken
        ) {
            self.token = token
            self.model = model

            super.init()

            model.didChange
                .subscribe(onNext: { [weak self] state in
                    guard let this = self else { return }

                    switch state {
                    case .firstFetching:
                        this.mediator?.presentLoadingState()

                    case let .fetching(previousStargazers: stargazers):
                        this.stargazers = stargazers
                        this.mediator?.presentLoadingState()

                    case let .fetched(stargazers: stargazers, error: .none):
                        this.stargazers = stargazers
                        this.mediator?.presentCompleteState()

                    case let .fetched(stargazers: stargazers, error: .some(error)):
                        this.stargazers = stargazers
                        this.mediator?.presentCompleteState()
                        this.mediator?.present(error: error)
                    }

                    this.mediator?.reload()
                })
                .addDisposableTo(self.disposeBag)
        }


        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.stargazers.count
        }


        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return StargazerCell.dequeue(
                cellOf: self.stargazers[indexPath.row],
                by: tableView,
                for: indexPath,
                andMustHave: self.token
            )
        }
    }
}