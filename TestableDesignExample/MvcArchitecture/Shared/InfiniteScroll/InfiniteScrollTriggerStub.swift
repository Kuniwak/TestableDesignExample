import UIKit
@testable import TestableDesignExample



class InfiniteScrollTriggerStub: InfiniteScrollTriggerProtocol {
    var nextResult: Bool


    init(firstResult: Bool) {
        self.nextResult = firstResult
    }


    func shouldLoadY(contentOffset: CGPoint, contentSize: CGSize, scrollViewSize: CGSize) -> Bool {
        return self.nextResult
    }
}