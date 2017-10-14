enum StargazersModelState {
    case fetched(stargazers: [GitHubUser], error: FailureReason?)
    case fetching(previousStargazers: [GitHubUser])


    static func from(pagingModelState: PagingModelState<GitHubUser>) -> StargazersModelState {
        switch pagingModelState {
        case let .fetching(beforeElements: stargazers):
            return .fetching(previousStargazers: stargazers)

        case let .fetched(elements: stargazers, error: error):
            return .fetched(
                stargazers: stargazers,
                error: FailureReason.from(pagingModelError: error)
            )
        }
    }


    enum FailureReason: Error {
        case apiError(debugInfo: String)


        static func from(pagingModelError: PagingModelState<GitHubUser>.ModelError?) -> FailureReason? {
            guard let pagingModelError = pagingModelError else {
                return nil
            }

            return .apiError(debugInfo: "\(pagingModelError)")
        }
    }
}



extension StargazersModelState: Equatable {
    static func ==(lhs: StargazersModelState, rhs: StargazersModelState) -> Bool {
        switch (lhs, rhs) {
        case let (.fetched(stargazers: ls, error: le), .fetched(stargazers: rs, error: re)):
            return ls == rs && le == re
        case let (.fetching(previousStargazers: ls), .fetching(previousStargazers: rs)):
            return ls == rs
        default:
            return false
        }
    }
}



extension StargazersModelState.FailureReason: Equatable {
    static func ==(lhs: StargazersModelState.FailureReason, rhs: StargazersModelState.FailureReason) -> Bool {
        switch (lhs, rhs) {
        case (.apiError, .apiError):
            return true
        }
    }
}
