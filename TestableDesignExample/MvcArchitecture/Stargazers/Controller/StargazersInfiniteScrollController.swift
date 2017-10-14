import UIKit
import RxSwift
import RxCocoa



protocol StargazersInfiniteScrollControllerProtocol {}



class StargazersInfiniteScrollController: StargazersInfiniteScrollControllerProtocol {
    private let injectable: RxCocoaInjectable.InjectableUIScrollView
    private let model: StargazersModelProtocol
    private let trigger: InfiniteScrollTriggerProtocol
    private let disposeBag = RxSwift.DisposeBag()


    init(
        watching injectable: RxCocoaInjectable.InjectableUIScrollView,
        determiningBy trigger: InfiniteScrollTriggerProtocol,
        notifying model: StargazersModelProtocol
    ) {
        self.injectable = injectable
        self.model = model
        self.trigger = trigger

        self.injectable
            .didScroll
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let this = self else { return }

                let scrollView = this.injectable.scrollView

                if this.trigger.shouldLoadY(
                    contentOffset:  scrollView.contentOffset,
                    contentSize: scrollView.contentSize,
                    scrollViewSize: scrollView.bounds.size
                ) {
                    this.model.fetchNext()
                }
            })
            .disposed(by: self.disposeBag)
    }
}
