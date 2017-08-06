import Result
import RxSwift



protocol StargazerModelContract {
    var didChange: RxSwift.Observable<StargazerModelState> { get }
    var currentState: StargazerModelState { get }

    func fetchNext()
    func fetchPrevious()
    func clear()
    func recover()
}



enum StargazerModelState {
    case fetched(stargazers: [GitHubUser], error: StargazerModelError?)
    case fetching(previousStargazers: [GitHubUser])


    static func from(pagingModelState: PagingModelState<GitHubUser>) -> StargazerModelState {
        switch pagingModelState {
        case let .fetching(beforeElements: stargazers):
            return .fetching(previousStargazers: stargazers)

        case let .fetched(elements: stargazers, error: error):
            return .fetched(
                stargazers: stargazers,
                error: StargazerModelError.from(pagingModelError: error)
            )
        }
    }
}



enum StargazerModelError: Error {
    case apiError(debugInfo: String)


    static func from(pagingModelError: PagingModelState<GitHubUser>.ModelError?) -> StargazerModelError? {
        guard let pagingModelError = pagingModelError else {
            return nil
        }

        return .apiError(debugInfo: "\(pagingModelError)")
    }
}



class StargazerModel: StargazerModelContract {
    private let pagingModel: AnyPagingModel<GitHubUser>


    var didChange: Observable<StargazerModelState> {
        return self.pagingModel
            .didChange
            .map { StargazerModelState.from(pagingModelState: $0) }
    }


    var currentState: StargazerModelState {
        return StargazerModelState.from(
            pagingModelState: self.pagingModel.currentState
        )
    }


    init<PagingModel: PagingModelContract>(
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


    static func create<PageRepository: PageRepositoryContract> (
        requestingElementCountPerPage elementCount: Int,
        fetchingPageVia pageRepository: PageRepository
    ) -> StargazerModel where PageRepository.Element == GitHubUser {
        return StargazerModel(
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
