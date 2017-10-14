import UIKit
import RxSwift
import RxCocoa



protocol StargazersRefreshControllerProtocol {}



class StargazersRefreshController: StargazersRefreshControllerProtocol {
    private let refreshController: UIRefreshControl
    private let model: StargazersModelProtocol
    private let disposeBag = RxSwift.DisposeBag()


    init(
        watching refreshController: UIRefreshControl,
        notifying model: StargazersModelProtocol
    ) {
        self.refreshController = refreshController
        self.model = model

        self.refreshController.rx
            .controlEvent(.valueChanged)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let this = self else { return }

                this.model.clear()
                this.model.fetchNext()
            })
            .disposed(by: self.disposeBag)
    }
}
