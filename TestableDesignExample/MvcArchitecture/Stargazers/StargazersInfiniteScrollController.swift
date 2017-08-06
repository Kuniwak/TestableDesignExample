import UIKit



protocol StargazersInfiniteScrollControllerContract {}



class StargazersInfiniteScrollController: NSObject, StargazersInfiniteScrollControllerContract, UIScrollViewDelegate {
    private let model: StargazerModelContract


    init(willRequestNextPageVia model: StargazerModelContract) {
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
