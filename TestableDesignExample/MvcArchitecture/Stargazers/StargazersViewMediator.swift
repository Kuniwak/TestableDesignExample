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
    private let lifter: LifterContract
    private let views: Views
    typealias Views = (
        tableView: UITableView,
        progressView: UIProgressView,
        refreshControl: UIRefreshControl
    )


    var visibleStargazers: [GitHubUser] {
        return self.dataSource.stargazers
    }



    init(
        observing model: StargazerModelContract,
        handling views: Views,
        presentingModelBy lifter: LifterContract
    ) {
        self.model = model
        self.views = views
        self.lifter = lifter

        let token = StargazerCell.register(to: views.tableView)
        self.dataSource = DataSource(
            observing: model,
            andMustHave: token
        )

        self.dataSource.mediator = self
        self.views.tableView.dataSource = self.dataSource
    }


    private func decorate() {
        self.views.refreshControl.backgroundColor = ColorCatalog.Weak.font
        self.views.refreshControl.isOpaque = true
    }



    func reload() {
        self.views.tableView.reloadData()
    }



    func presentCompleteState() {
        guard self.views.refreshControl.isRefreshing else {
            self.views.progressView.setProgress(1.0, animated: true)
            self.views.progressView.isHidden = true
            return
        }

        self.views.refreshControl.endRefreshing()
    }



    func presentLoadingState() {
        guard self.views.refreshControl.isRefreshing else {
            return
        }

        // NOTE: Fake progress X-D
        self.views.progressView.isHidden = false
        self.views.progressView.setProgress(0.8, animated: true)
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

        self.lifter.present(
            viewController: alertController,
            animated: true
        )
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