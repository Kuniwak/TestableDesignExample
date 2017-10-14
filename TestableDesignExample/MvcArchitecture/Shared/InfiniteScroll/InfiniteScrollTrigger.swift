import UIKit



protocol InfiniteScrollTriggerProtocol {
    func shouldLoadY(
        contentOffset: CGPoint,
        contentSize: CGSize,
        scrollViewSize: CGSize
    ) -> Bool
}



class InfiniteScrollThresholdTrigger: InfiniteScrollTriggerProtocol {
    private let threshold: CGFloat


    init(basedOn threshold: CGFloat) {
        self.threshold = threshold
    }


    func shouldLoadY(
        contentOffset: CGPoint,
        contentSize: CGSize,
        scrollViewSize: CGSize
    ) -> Bool {
        let offsetY = contentOffset.y
        let contentHeight = contentSize.height
        let visibleHeight = scrollViewSize.height

        return offsetY >= contentHeight
            - visibleHeight
            - threshold
    }
}
