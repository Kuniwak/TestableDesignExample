import PromiseKit



protocol PageRepositoryContract {
    associatedtype Element: Hashable

    func fetch(pageOf pageNumber: Int) -> Promise<[Element]>
}



extension PageRepositoryContract {
    func asAny() -> AnyPageRepository<Element> {
        return AnyPageRepository<Element>(wrapping: self)
    }
}



class AnyPageRepository<T: Hashable>: PageRepositoryContract {
    typealias Element = T


    private let _fetch: (Int) -> Promise<[Element]>


    init<WrappedRepository: PageRepositoryContract>(
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
