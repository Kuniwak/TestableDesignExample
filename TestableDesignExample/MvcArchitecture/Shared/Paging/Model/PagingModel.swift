import RxSwift
import RxCocoa



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
protocol PagingModelProtocol {
    associatedtype Element: Hashable

    var currentState: PagingModelState<Element> { get }
    var didChange: RxCocoa.Driver<PagingModelState<Element>> { get }

    func fetchNext()
    func fetchPrevious()
    func clear()
    func recover()
}



extension PagingModelProtocol {
    func asAny() -> AnyPagingModel<Element> {
        return AnyPagingModel(wrapping: self)
    }
}



enum PagingModelState<Element> {
    case fetched(elements: [Element], error: ModelError?)
    case fetching(beforeElements: [Element])


    enum ModelError: Error {
        case unspecified(debugInfo: String)
    }
}



class PagingModel<T: Hashable>: PagingModelProtocol {
    typealias Element = T

    private let stateMachine: StateMachine<PagingModelState<Element>>
    private let pageRepository: AnyPageRepository<Element>
    private let pageEndStrategy: AnyPageEndDetectionStrategy<Element>
    private let cursor: PagingCursorProtocol


    var didChange: RxCocoa.Driver<PagingModelState<Element>> {
        return self.stateMachine.didChange
    }


    var currentState: PagingModelState<Element> {
        return self.stateMachine.currentState
    }


    init<
        PageRepository: PageRepositoryProtocol,
        PageEndStrategy: PageEndDetectionStrategyProtocol
    >(
        fetchingPageVia pageRepository: PageRepository,
        detectingPageEndBy pageEndStrategy: PageEndStrategy,
        choosingPageNumberBy cursor: PagingCursorProtocol
    ) where
        PageRepository.Element == Element,
        PageEndStrategy.Element == Element
    {
        self.stateMachine = StateMachine<PagingModelState<Element>>(startingWith: .fetched(
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
            self.stateMachine.transit(to: .fetched(
                elements: [],
                error: nil
            ))
        }
    }


    func recover() {
        switch self.currentState {
        case .fetching:
            return

        case let .fetched(elements: storedCollection, error: _):
            self.stateMachine.transit(to: .fetched(
                elements: storedCollection,
                error: nil
            ))
        }
    }


    private func fetch(to direction: PageEndDirection) {
        switch self.currentState {
        case .fetching:
            return

        case let .fetched(elements: storedElements, error: _):
            self.stateMachine.transit(to: .fetching(
                beforeElements: storedElements
            ))

            let pageNumber = self.cursor.getPageNumber(of: direction)

            self.pageRepository
                .fetch(pageOf: pageNumber)
                .done { (fetchedElements: [Element]) -> Void in
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

                    self.stateMachine.transit(to: .fetched(
                        elements: PagedElementCollection.append(
                            storedElements,
                            and: fetchedElements
                        ),
                        error: nil
                    ))
                }
                .catch { error in
                    self.stateMachine.transit(to: .fetched(
                        elements: storedElements,
                        error: .unspecified(debugInfo: "\(error)")
                    ))
                }
        }
    }
}



class AnyPagingModel<T: Hashable>: PagingModelProtocol {
    typealias Element = T
    private let _currentState: () -> PagingModelState<Element>
    private let _didChange: () -> RxCocoa.Driver<PagingModelState<Element>>
    private let _fetchNext: () -> Void
    private let _fetchPrevious: () -> Void
    private let _clear: () -> Void
    private let _recover: () -> Void


    init<WrappedModel: PagingModelProtocol>(
        wrapping wrappedModel: WrappedModel
    ) where WrappedModel.Element == Element {
        self._currentState = { wrappedModel.currentState }
        self._didChange = { wrappedModel.didChange }
        self._fetchNext = { wrappedModel.fetchNext() }
        self._fetchPrevious = { wrappedModel.fetchPrevious() }
        self._clear = { wrappedModel.clear() }
        self._recover = { wrappedModel.recover() }
    }


    var currentState: PagingModelState<Element> {
        return self._currentState()
    }


    var didChange: RxCocoa.Driver<PagingModelState<Element>> {
        return self._didChange()
    }


    func fetchNext() {
        self._fetchNext()
    }


    func fetchPrevious() {
        self._fetchPrevious()
    }


    func clear() {
        self._clear()
    }


    func recover() {
        self._recover()
    }
}
