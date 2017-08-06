class PageElementCountStrategy<T: Hashable>: PageEndDetectionStrategyContract {
    typealias Element = T
    private let count: Int


    init(requestingElementCountPerPage count: Int) {
        self.count = count
    }


    func isPageEnd(
        fetching pageNumber: Int,
        to direction: PageEndDirection,
        storedCollection: [Element],
        fetchedCollection: [Element]
    ) -> Bool {
        return fetchedCollection.count < self.count
    }
}
