@testable import TestableDesignExample



class PageEndDetectionStrategyStub<T>: PageEndDetectionStrategyProtocol {
    typealias Element = T


    private let range: Range<Int>


    init(
        whereCursorMovingOn range: Range<Int>
    ) {
        self.range = range
    }


    func isPageEnd(
        fetching pageNumber: Int,
        to direction: PageEndDirection,
        storedCollection: [Element],
        fetchedCollection: [Element]
    ) -> Bool {
        return !(range ~= pageNumber)
    }
}