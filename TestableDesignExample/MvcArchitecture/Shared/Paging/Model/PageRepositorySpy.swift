import PromiseKit
@testable import TestableDesignExample



class PageRepositorySpy<T: Hashable>: PageRepositoryStub<T> {
    private(set) var calledArguments = [Int]()


    override func fetch(pageOf pageNumber: Int) -> Promise<[Element]> {
        self.calledArguments.append(pageNumber)

        return super.fetch(pageOf: pageNumber)
    }
}
