import UIKit
import RxSwift
import RxCocoa



protocol StargazersInfiniteScrollControllerProtocol {}



class StargazersInfiniteScrollController: StargazersInfiniteScrollControllerProtocol {
    private let scrollView: UIScrollView
    private let model: StargazerModelProtocol
    private let disposeBag = RxSwift.DisposeBag()


    init(
        watching scrollView: UIScrollView,
        notifying model: StargazerModelProtocol
    ) {
        self.scrollView = scrollView
        self.model = model

        self.scrollView.rx
            .didScroll
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let this = self else { return }

                let offsetY = this.scrollView.contentOffset.y
                let contentHeight = this.scrollView.contentSize.height
                let visibleHeight = this.scrollView.bounds.height

                let isReachingThreshold = offsetY >= contentHeight
                    - visibleHeight
                    - PerformanceParameter.stargazersInfiniteScrollThreshold

                if isReachingThreshold {
                    this.model.fetchNext()
                }
            })
            .disposed(by: self.disposeBag)
    }
}
