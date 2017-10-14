import Result
import RxSwift



protocol StargazersModelProtocol {
    var didChange: RxSwift.Observable<StargazersModelState> { get }
    var currentState: StargazersModelState { get }

    func fetchNext()
    func fetchPrevious()
    func clear()
    func recover()
}



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



class StargazersModel: StargazersModelProtocol {
    private let pagingModel: AnyPagingModel<GitHubUser>


    var didChange: Observable<StargazersModelState> {
        return self.pagingModel
            .didChange
            .map { StargazersModelState.from(pagingModelState: $0) }
    }


    var currentState: StargazersModelState {
        return StargazersModelState.from(
            pagingModelState: self.pagingModel.currentState
        )
    }


    init<PagingModel: PagingModelProtocol>(
        pagingBy pagingModel: PagingModel
    ) where PagingModel.Element == GitHubUser {
        self.pagingModel = pagingModel.asAny()
    }


    func fetchNext() {
        self.pagingModel.fetchNext()
    }


    func fetchPrevious() {
        self.pagingModel.fetchPrevious()
    }


    func clear() {
        self.pagingModel.clear()
    }


    func recover() {
        self.pagingModel.recover()
    }


    static func create<PageRepository: PageRepositoryProtocol> (
        requestingElementCountPerPage elementCount: Int,
        fetchingPageVia pageRepository: PageRepository
    ) -> StargazersModel where PageRepository.Element == GitHubUser {
        return StargazersModel(
            pagingBy: PagingModel(
                fetchingPageVia: pageRepository,
                detectingPageEndBy: PageElementCountStrategy(
                    requestingElementCountPerPage: elementCount
                ),
                choosingPageNumberBy: PagingCursor(
                    whereMovingOn: PagingCursor.standardDomain
                )
            )
        )
    }
}
