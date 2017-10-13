import UIKit



protocol StargazersInfiniteScrollControllerProtocol {}



class StargazersInfiniteScrollController: NSObject, StargazersInfiniteScrollControllerProtocol, UIScrollViewDelegate {
    private let model: StargazerModelProtocol


    init(willRequestNextPageVia model: StargazerModelProtocol) {
        self.model = model
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.bounds.height

        let isReachingThreshold = offsetY >= contentHeight
            - visibleHeight
            - PerformanceParameter.stargazersInfiniteScrollThreshold

        if isReachingThreshold {
            self.model.fetchNext()
        }
    }
}
