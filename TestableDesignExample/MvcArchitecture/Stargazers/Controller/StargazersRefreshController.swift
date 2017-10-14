import UIKit
import RxSwift
import RxCocoa



protocol StargazersRefreshControllerProtocol {}



class StargazersRefreshController: StargazersRefreshControllerProtocol {
    private let injectable: RxCocoaInjectable.InjectableUIRefreshControl
    private let model: StargazersModelProtocol
    private let disposeBag = RxSwift.DisposeBag()


    init(
        watching injectable: RxCocoaInjectable.InjectableUIRefreshControl,
        notifying model: StargazersModelProtocol
    ) {
        self.injectable = injectable
        self.model = model

        self.injectable.valueChanged
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let this = self else { return }

                this.model.clear()
                this.model.fetchNext()
            })
            .disposed(by: self.disposeBag)
    }
}
