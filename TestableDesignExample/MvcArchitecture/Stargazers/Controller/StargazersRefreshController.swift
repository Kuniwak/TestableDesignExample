import UIKit
import RxSwift
import RxCocoa



protocol StargazersRefreshControllerProtocol {}



class StargazersRefreshController: StargazersRefreshControllerProtocol {
    private let refreshControlEvent: RxCocoa.Signal<Void>
    private let model: StargazersModelProtocol
    private let disposeBag = RxSwift.DisposeBag()


    init(
        watching refreshControlEvent: RxCocoa.Signal<Void>,
        notifying model: StargazersModelProtocol
    ) {
        self.refreshControlEvent = refreshControlEvent
        self.model = model
        
        self.refreshControlEvent
            .emit(onNext: { [weak self] _ in
                guard let this = self else { return }

                this.model.clear()
                this.model.fetchNext()
            })
            .disposed(by: self.disposeBag)
    }
}
