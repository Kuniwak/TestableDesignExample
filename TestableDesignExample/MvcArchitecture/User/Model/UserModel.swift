import RxSwift
import RxCocoa
import Result



protocol UserModelProtocol: class {
    var didChange: RxCocoa.Driver<UserModelState> { get }
    var currentState: UserModelState { get }

    func fetch()
}



enum UserModelState {
    case fetched(result: Result<GitHubUser, ModelError>)
    case fetching


    enum ModelError: Error {
        case unspecified(debugInfo: String)
    }
}



class UserModel: UserModelProtocol {
    private let id: GitHubUser.Id
    private let stateMachine: StateMachine<UserModelState>
    private let repository: UserRepositoryProtocol


    var didChange: RxCocoa.Driver<UserModelState> {
        return self.stateMachine.didChange
    }


    var currentState: UserModelState {
        return self.stateMachine.currentState
    }


    init(
        for id: GitHubUser.Id,
        withInitialState initialState: UserModelState,
        fetchingVia repository: UserRepositoryProtocol
    ) {
        self.id = id
        self.stateMachine = StateMachine<UserModelState>(startingWith: initialState)
        self.repository = repository
    }


    func fetch() {
        switch self.currentState {
        case .fetching:
            return

        case .fetched:
            self.stateMachine.transit(to: .fetching)

            self.repository.get(by: self.id)
                .done { user in
                    self.stateMachine.transit(to: .fetched(
                        result: .success(user)
                    ))
                }
                .catch { error in
                    self.stateMachine.transit(to: .fetched(
                        result: .failure(.unspecified(debugInfo: "\(error)"))
                    ))
                }
        }
    }
}
