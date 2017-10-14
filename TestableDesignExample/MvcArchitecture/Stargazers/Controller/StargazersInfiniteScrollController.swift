import UIKit
import RxSwift
import RxCocoa



protocol StargazersInfiniteScrollControllerProtocol {}



class StargazersInfiniteScrollController: StargazersInfiniteScrollControllerProtocol {
    private let scrollView: UIScrollView
    private let model: StargazersModelProtocol
    private let thresholdDetector: InfiniteScrollTriggerProtocol
    private let disposeBag = RxSwift.DisposeBag()
    internal var didHandle = {}


    init(
        watching scrollView: UIScrollView,
        determiningBy thresholdDetector: InfiniteScrollTriggerProtocol,
        notifying model: StargazersModelProtocol
    ) {
        self.scrollView = scrollView
        self.model = model
        self.thresholdDetector = thresholdDetector

        self.scrollView.rx
            .didScroll
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let this = self else { return }

                if thresholdDetector.shouldLoadY(
                    contentOffset:  this.scrollView.contentOffset,
                    contentSize: this.scrollView.contentSize,
                    scrollViewSize: this.scrollView.bounds.size
                ) {
                    this.model.fetchNext()
                }

                this.didHandle()
            })
            .disposed(by: self.disposeBag)
    }
}
