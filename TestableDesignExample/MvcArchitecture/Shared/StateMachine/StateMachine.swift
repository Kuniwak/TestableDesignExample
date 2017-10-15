import RxSwift



class StateMachine<State> {
    private let variable: RxSwift.Variable<State>


    init(startingWith initialState: State) {
        self.variable = RxSwift.Variable<State>(initialState)
    }


    var currentState: State {
        return self.variable.value
    }


    var didChange: RxSwift.Observable<State> {
        return self.variable.asObservable()
    }


    func transit(to nextState: State) {
        self.variable.value = nextState
    }
}
