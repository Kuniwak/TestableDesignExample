import RxSwift
@testable import TestableDesignExample



class StargazersModelStub: StargazersModelProtocol {
    private let stateMachine: StateMachine<StargazersModelState>


    var didChange: Observable<StargazersModelState> {
        return self.stateMachine.didChange
    }


    var currentState: StargazersModelState {
        get {
            return self.stateMachine.currentState
        }

        set {
            self.stateMachine.transit(to: newValue)
        }
    }


    init(withInitialState initialState: StargazersModelState = .fetched(stargazers: [], error: nil)) {
        self.stateMachine = StateMachine<StargazersModelState>(startingWith: initialState)
    }


    func fetchNext() {}
    func fetchPrevious() {}
    func clear() {}
    func recover() {}
}