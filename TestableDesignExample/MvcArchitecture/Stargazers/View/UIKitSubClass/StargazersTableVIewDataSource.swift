import UIKit
import RxSwift



protocol StargazersTableViewDataSourceProtocol: class {
    var visibleStargazers: [GitHubUser] { get }
}



class StargazersTableViewDataSource: NSObject {
    fileprivate let token: StargazerCell.RegistrationToken
    fileprivate let tableView: UITableView
    fileprivate let model: StargazerModelProtocol

    fileprivate var stargazers = [GitHubUser]()
    fileprivate let disposeBag = RxSwift.DisposeBag()


    init(
        observing model: StargazerModelProtocol,
        handling tableView: UITableView
    ) {
        self.model = model
        self.tableView = tableView
        self.token = StargazerCell.register(to: tableView)

        super.init()

        model.didChange
            .subscribe(onNext: { [weak self] state in
                guard let this = self else { return }

                switch state {
                case let .fetching(previousStargazers: stargazers):
                    this.stargazers = stargazers

                case let .fetched(stargazers: stargazers, error: _):
                    this.stargazers = stargazers
                }

                this.tableView.reloadData()
            })
            .disposed(by: self.disposeBag)
    }
}



extension StargazersTableViewDataSource: StargazersTableViewDataSourceProtocol {
    var visibleStargazers: [GitHubUser] {
        return self.stargazers
    }
}



extension StargazersTableViewDataSource: UITableViewDataSource {
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
