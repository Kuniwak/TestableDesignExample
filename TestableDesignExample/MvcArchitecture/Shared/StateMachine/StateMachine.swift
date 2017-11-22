import RxSwift
import RxCocoa



class StateMachine<State> {
    private let relay: RxCocoa.BehaviorRelay<State>


    init(startingWith initialState: State) {
        self.relay = RxCocoa.BehaviorRelay<State>(value: initialState)
    }


    var currentState: State {
        return self.relay.value
    }


    var didChange: RxCocoa.Driver<State> {
        return self.relay.asDriver()
    }


    func transit(to nextState: State) {
        self.relay.accept(nextState)
    }
}
