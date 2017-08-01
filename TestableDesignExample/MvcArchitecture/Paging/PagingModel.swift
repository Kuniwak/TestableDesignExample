import RxSwift



/**
 A model for paged API.

 # State Transition Diagram

 ```
                                                     |
                                                     V
 +-------------------------------------------------->*<----------------------------------------------------+
 |                                                   |                                                     |
 |                                                   V                                                     |
 |                                                   *<-------------------------------------------------+  |
 |                                                   |                                                  |  |
 |                          +------------------------*-------------------------+                        |  |
 |                          |                                                  |                        |  |
 |                      (success)                                           (failed)                    |  |
 |  +-- recover ---+        |         +--------------+                         |                        |  |
 |  |              V        V         V              |                         V                        |  |
 |  |  +------------------------------------------+  |  +--------------------------------------------+  |  |
 |  +--| fetched(elements: [Element], error: nil) |  |  | fetched(elements: [Element], error: error) |  |  |
 |     +------------------------------------------+  |  +--------------------------------------------+  |  |
 |                 |        |                        |               |         |         |              :  |
 +----- clear -----+        |                        +--- recover ---+         |         +----- clear -----+
                            |                                                  |                        :
                            +----------------------->*<------------------------+                        |
                                                     |                                                  |
                                           fetchPrevious,fetchNext                                      |
                                                     |                                                  |
                         +-----------------------+   |                                                  |
                         |                       |   |                                                  |
       fetchPrevious,fetchNext,clear,recover     |   |                                                  |
                         |                       V   V                                                  |
                         |            +-------------------------------+                                 |
                         +------------| fetching(elements: [Element]) |                                 |
                                      +-------------------------------+                                 |
                                                     |                                                  |
                                                     +--------------------------------------------------+
 ```
 */
protocol PagingModelContract {
    associatedtype Element: Hashable

    var didChange: RxSwift.Observable<PagingModelState<Element>> { get }

    func fetchNext()
    func fetchPrevious()
    func clear()
    func recover()
}



enum PagingModelState<Element> {
    case fetched(elements: [Element], error: ModelError?)
    case fetching(beforeElements: [Element])


    enum ModelError: Error {
        case unspecified(debugInfo: String)
    }
}



class PagingModel<T: Hashable>: PagingModelContract {
    typealias Element = T


    var didChange: Observable<PagingModelState<Element>> {
        return self.stateVariable.asObservable()
    }


    private let stateVariable: RxSwift.Variable<PagingModelState<Element>>
    private let pageRepository: AnyPageRepository<Element>
    private let pageEndStrategy: AnyPageEndDetectionStrategy<Element>
    private let cursor: PagingCursorContract


    fileprivate(set) var currentState: PagingModelState<Element> {
        get {
            return self.stateVariable.value
        }
        set {
            self.stateVariable.value = newValue
        }
    }


    init<
        PageRepository: PageRepositoryContract,
        PageEndStrategy: PageEndDetectionStrategyContract
    >(
        fetchingPageVia pageRepository: PageRepository,
        detectingPageEndBy pageEndStrategy: PageEndStrategy,
        choosingPageNumberBy cursor: PagingCursorContract
    ) where
        PageRepository.Element == Element,
        PageEndStrategy.Element == Element
    {
        self.stateVariable = RxSwift.Variable<PagingModelState<Element>>(.fetched(
            elements: [],
            error: nil
        ))

        self.pageRepository = pageRepository.asAny()
        self.pageEndStrategy = pageEndStrategy.asAny()
        self.cursor = cursor
    }


    func fetchNext() {
        self.fetch(to: .next)
    }


    func fetchPrevious() {
        self.fetch(to: .previous)
    }


    func clear() {
        switch self.currentState {
        case .fetching:
            return

        case .fetched:
            self.cursor.reset()
            self.currentState = .fetched(elements: [], error: nil)
        }
    }


    func recover() {
        switch self.currentState {
        case .fetching:
            return

        case let .fetched(elements: storedCollection, error: _):
            self.currentState = .fetched(elements: storedCollection, error: nil)
        }
    }


    private func fetch(to direction: PageEndDirection) {
        switch self.currentState {
        case .fetching:
            return

        case let .fetched(elements: storedElements, error: _):
            self.currentState = .fetching(beforeElements: storedElements)

            let pageNumber = self.cursor.getPageNumber(of: direction)

            self.pageRepository
                .fetch(pageOf: pageNumber)
                .then { (fetchedElements: [Element]) -> Void in
                    let isPageEnd = self.pageEndStrategy.isPageEnd(
                        fetching: pageNumber,
                        to: direction,
                        storedCollection: storedElements,
                        fetchedCollection: fetchedElements
                    )

                    self.cursor.fetchingDidSucceed(
                        for: direction,
                        isPageEnd: isPageEnd
                    )

                    self.currentState = .fetched(
                        elements: PagedElementCollection.append(
                            storedElements,
                            and: fetchedElements
                        ),
                        error: nil
                    )
                }
                .catch { error in
                    self.currentState = .fetched(
                        elements: storedElements,
                        error: .unspecified(debugInfo: "\(error)")
                    )
                }
        }
    }
}
