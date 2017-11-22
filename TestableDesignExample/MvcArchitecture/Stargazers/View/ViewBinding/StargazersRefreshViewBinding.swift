import UIKit
import RxSwift


protocol StargazersRefreshViewBindingProtocol {}


class StargazersRefreshViewBinding: StargazersRefreshViewBindingProtocol {
    private let disposeBag = RxSwift.DisposeBag()
    private let model: StargazersModelProtocol
    private let refreshControl: UIRefreshControl


    init(
        observing model: StargazersModelProtocol,
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