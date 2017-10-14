import PromiseKit



protocol PageRepositoryProtocol {
    associatedtype Element: Hashable

    func fetch(pageOf pageNumber: Int) -> Promise<[Element]>
}



extension PageRepositoryProtocol {
    func asAny() -> AnyPageRepository<Element> {
        return AnyPageRepository<Element>(wrapping: self)
    }
}



class AnyPageRepository<T: Hashable>: PageRepositoryProtocol {
    typealias Element = T


    private let _fetch: (Int) -> Promise<[Element]>


    init<WrappedRepository: PageRepositoryProtocol>(
        wrapping wrappedRepository: WrappedRepository
    ) where WrappedRepository.Element == Element {
        self._fetch = { pageNumber in
            return wrappedRepository.fetch(pageOf: pageNumber)
        }
    }


    func fetch(pageOf pageNumber: Int) -> Promise<[Element]> {
        return self._fetch(pageNumber)
    }
}
