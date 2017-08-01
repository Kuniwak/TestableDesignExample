import PromiseKit
@testable import TestableDesignExample



class PageRepositoryStub<T: Hashable>: PageRepositoryContract {
    typealias Element = T


    private let block: (Int) -> Promise<[Element]>


    init(willReturn block: @escaping (Int) -> Promise<[Element]>) {
        self.block = block
    }


    func fetch(pageOf pageNumber: Int) -> Promise<[Element]> {
        return self.block(pageNumber)
    }
}