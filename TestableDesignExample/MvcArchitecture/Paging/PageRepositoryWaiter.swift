import PromiseKit
@testable import TestableDesignExample



class PageRepositoryWaiter<T: Hashable>: PageRepositoryStub<T> {
    private let completionHandler: (Int) -> Void


    init(
        willReturn block: @escaping (Int) -> Promise<[Element]>,
        willInvokeWhenFetched completionHandler: @escaping (Int) -> Void
    ) {
        self.completionHandler = completionHandler

        super.init(willReturn: block)
    }


    override func fetch(pageOf pageNumber: Int) -> Promise<[Element]> {
        return super.fetch(pageOf: pageNumber)
            .then { elements -> [Element] in
                self.completionHandler(pageNumber)
                return elements
            }
    }
}
