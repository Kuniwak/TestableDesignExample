import Result
import RxSwift



protocol StargazerModelContract {
    var didChange: RxSwift.Observable<StargazerModelState> { get }
    var currentState: StargazerModelState { get }

    func fetch()
}



enum StargazerModelState {
    case firstFetching
    case fetched(stargazers: [GitHubUser], error: StargazerModelError?)
    case fetching(previousStargazers: [GitHubUser])
}



enum StargazerModelError: Error {
    case apiError(debugInfo: String)
}



class StargazerModel: StargazerModelContract {
    private let stateVariable: RxSwift.Variable<StargazerModelState>
    private let repository: GitHubRepository
    private let stargazersRepository: StargazerRepositoryContract


    var didChange: Observable<StargazerModelState> {
        return self.stateVariable.asObservable()
    }


    var currentState: StargazerModelState {
        return self.stateVariable.value
    }


    init(for repository: GitHubRepository, fetchingVia stargazersRepository: StargazerRepositoryContract) {
        self.repository = repository
        self.stargazersRepository = stargazersRepository

        self.stateVariable = RxSwift.Variable(.firstFetching)
        self.fetchWitStateTransition()
    }


    func fetch() {
        switch self.currentState {
        case .firstFetching, .fetching:
            // Do nothing. Because already fetch was started.
            return
        case let .fetched(stargazers: stargazers, error: _):
            self.transitState(to: .fetching(previousStargazers: stargazers))

            self.fetchWitStateTransition()
        }
    }


    private func fetchWitStateTransition() {
        self.stargazersRepository.get(stargazersOf: self.repository)
            .then { [weak self] users -> Void in
                guard let this = self else { return }

                this.transitState(to: .fetched(
                    stargazers: users,
                    error: nil
                ))
            }
            .catch { [weak self] error in
                guard let this = self else { return }

                switch this.currentState {
                case .firstFetching:
                    // Hold empty repositories and set the error.
                    this.transitState(to: .fetched(
                        stargazers: [],
                        error: .apiError(debugInfo: "\(error)")
                    ))

                case let .fetching(previousStargazers: stargazers):
                    // Hold previous repositories and set the error.
                    this.transitState(to: .fetched(
                        stargazers: stargazers,
                        error: .apiError(debugInfo: "\(error)")
                    ))

                case let .fetched(stargazers: stargazers, error: _):
                    // Hold previous repositories and replace the old error by the new one.
                    this.transitState(to: .fetched(
                        stargazers: stargazers,
                        error: .apiError(debugInfo: "\(error)")
                    ))
                }
            }
    }



    private func transitState(to nextState: StargazerModelState) {
        self.stateVariable.value = nextState
    }
}
