import UIKit



extension EventSimulator {
    static func simulateScroll(on scrollView: UIScrollView, to offset: CGPoint) {
        scrollView.setContentOffset(offset, animated: false)
    }
}