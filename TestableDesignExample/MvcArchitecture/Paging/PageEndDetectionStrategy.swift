protocol PageEndDetectionStrategyContract {
    associatedtype Element

    func isPageEnd(
        fetching pageNumber: Int,
        to direction: PageEndDirection,
        storedCollection: [Element],
        fetchedCollection: [Element]
    ) -> Bool
}



extension PageEndDetectionStrategyContract {
    func asAny() -> AnyPageEndDetectionStrategy<Element> {
        return AnyPageEndDetectionStrategy<Element>(wrapping: self)
    }
}



class AnyPageEndDetectionStrategy<T>: PageEndDetectionStrategyContract {
    typealias Element = T


    private let _isPageEnd: (Int, PageEndDirection, [Element], [Element]) -> Bool


    init<WrappedStrategy: PageEndDetectionStrategyContract>(
        wrapping wrappedStrategy: WrappedStrategy
    ) where WrappedStrategy.Element == Element {
        self._isPageEnd = { (pageNumber, direction, storedCollection, fetchedCollection) in
            return wrappedStrategy.isPageEnd(
                fetching: pageNumber,
                to: direction,
                storedCollection: storedCollection,
                fetchedCollection: fetchedCollection
            )
        }
    }


    func isPageEnd(
        fetching pageNumber: Int,
        to direction: PageEndDirection,
        storedCollection: [Element],
        fetchedCollection: [Element]
    ) -> Bool {
        return self._isPageEnd(
            pageNumber,
            direction,
            storedCollection,
            fetchedCollection
        )
    }
}
