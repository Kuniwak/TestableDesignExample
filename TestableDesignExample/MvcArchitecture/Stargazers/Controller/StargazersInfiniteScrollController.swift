import UIKit
import RxSwift
import RxCocoa



protocol StargazersInfiniteScrollControllerProtocol {}



class StargazersInfiniteScrollController: StargazersInfiniteScrollControllerProtocol {
    private let scrollViewDidScroll: RxCocoa.Signal<Void>
    private let scrollView: UIScrollView
    private let model: StargazersModelProtocol
    private let trigger: InfiniteScrollTriggerProtocol
    private let disposeBag = RxSwift.DisposeBag()


    init(
        watching scrollViewDidScroll: RxCocoa.Signal<Void>,
        handling scrollView: UIScrollView,
        determiningBy trigger: InfiniteScrollTriggerProtocol,
        notifying model: StargazersModelProtocol
    ) {
        self.scrollViewDidScroll = scrollViewDidScroll
        self.scrollView = scrollView
        self.model = model
        self.trigger = trigger

        self.scrollViewDidScroll
            .emit(onNext: { [weak self] _ in
                guard let this = self else { return }

                let scrollView = this.scrollView

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
