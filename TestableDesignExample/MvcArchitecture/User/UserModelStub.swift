import RxSwift
@testable import TestableDesignExample



class UserModelStub: UserModelProtocol {
    private let stateVariable: RxSwift.Variable<UserModelState>


    init(withInitialState initialState: UserModelState) {
        self.stateVariable = RxSwift.Variable<UserModelState>(initialState)
    }


    var didChange: Observable<UserModelState> {
        return self.stateVariable.asObservable()
    }


    var currentState: UserModelState {
        get {
            return self.stateVariable.value
        }

        set {
            self.stateVariable.value = newValue
        }
    }
}