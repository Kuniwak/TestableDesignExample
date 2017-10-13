import UIKit
import RxSwift


protocol StargazersRefreshViewMediatorProtocol {
    weak var delegate: StargazersRefreshViewMediatorDelegate? { get set }
}


protocol StargazersRefreshViewMediatorDelegate: class {
}


class StargazersRefreshViewMediator: StargazersRefreshViewMediatorProtocol {
    private let disposeBag = RxSwift.DisposeBag()
    private let model: StargazerModelProtocol
    private let refreshControl: UIRefreshControl

    weak var delegate: StargazersRefreshViewMediatorDelegate?


    init(
        observing model: StargazerModelProtocol,
        handling refreshControl: UIRefreshControl
    ) {
        self.model = model
        self.refreshControl = refreshControl

        self.decorate()

        self.model
            .didChange
            .subscribe(onNext: { [weak self] state in
                guard let this = self else { return }

                switch state {
                case .fetching:
                    return

                case .fetched:
                    if this.refreshControl.isRefreshing {
                        this.refreshControl.endRefreshing()
                    }
                }
            })
            .disposed(by: self.disposeBag)
    }


    private func decorate() {
        self.refreshControl.backgroundColor = ColorCatalog.Weak.font
        self.refreshControl.isOpaque = true
    }
}