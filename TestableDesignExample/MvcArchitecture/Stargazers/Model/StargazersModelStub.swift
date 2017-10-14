import RxSwift
@testable import TestableDesignExample



class StargazersModelStub: StargazersModelProtocol {
    private let stateVariable: RxSwift.Variable<StargazersModelState>


    var didChange: Observable<StargazersModelState> {
        return self.stateVariable.asObservable()
    }


    var currentState: StargazersModelState {
        get {
            return self.stateVariable.value
        }

        set {
            self.stateVariable.value = newValue
        }
    }


    init(withInitialState initialState: StargazersModelState = .fetched(stargazers: [], error: nil)) {
        self.stateVariable = RxSwift.Variable<StargazersModelState>(initialState)
    }


    func fetchNext() {}
    func fetchPrevious() {}
    func clear() {}
    func recover() {}
}