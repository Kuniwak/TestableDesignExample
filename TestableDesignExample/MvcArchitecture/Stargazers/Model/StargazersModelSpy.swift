import RxSwift
@testable import TestableDesignExample



class StargazersModelSpy: StargazersModelProtocol {
    enum CallArgs: Equatable {
        case fetchNext
        case fetchPrevious
        case clear
        case recover
    }
    private(set) var callArgs: [CallArgs] = []


    var stub: StargazersModelProtocol


    var didChange: RxSwift.Observable<StargazersModelState> {
        return self.stub.didChange
    }


    var currentState: StargazersModelState {
        return self.stub.currentState
    }


    init(inheriting stub: StargazersModelProtocol = StargazersModelStub()) {
        self.stub = stub
    }


    func fetchNext() {
        self.stub.fetchNext()
        self.callArgs.append(.fetchNext)
    }


    func fetchPrevious() {
        self.stub.fetchPrevious()
        self.callArgs.append(.fetchPrevious)
    }


    func clear() {
        self.stub.clear()
        self.callArgs.append(.clear)
    }


    func recover() {
        self.stub.recover()
        self.callArgs.append(.recover)
    }
}
