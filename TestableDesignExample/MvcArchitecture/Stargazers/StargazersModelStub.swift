import RxSwift
@testable import TestableDesignExample



class StargazersModelStub: StargazerModelProtocol {
    private let stateVariable: RxSwift.Variable<StargazerModelState>


    var didChange: Observable<StargazerModelState> {
        return self.stateVariable.asObservable()
    }


    var currentState: StargazerModelState {
        get {
            return self.stateVariable.value
        }

        set {
            self.stateVariable.value = newValue
        }
    }


    init(withInitialState initialState: StargazerModelState) {
        self.stateVariable = RxSwift.Variable<StargazerModelState>(initialState)
    }


    func fetchNext() {}
    func fetchPrevious() {}
    func clear() {}
    func recover() {}
}