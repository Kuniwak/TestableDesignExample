import RxSwift
import Result



protocol UserModelContract: class {
    var didChange: RxSwift.Observable<UserModelState> { get }
    var currentState: UserModelState { get }
}



enum UserModelState {
    case fetched(result: Result<GitHubUser, ModelError>)
    case fetching


    enum ModelError: Error {
        case unspecified(debugInfo: String)
    }
}



class UserModel: UserModelContract {
    private let stateVariable: RxSwift.Variable<UserModelState>


    var didChange: RxSwift.Observable<UserModelState> {
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


    init(withInitialState initialState: UserModelState) {
        self.stateVariable = RxSwift.Variable<UserModelState>(initialState)
    }
}

