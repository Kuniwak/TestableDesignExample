import Result
import RxSwift
import RxCocoa



protocol StargazersModelProtocol {
    var didChange: RxCocoa.Driver<StargazersModelState> { get }
    var currentState: StargazersModelState { get }

    func fetchNext()
    func fetchPrevious()
    func clear()
    func recover()
}



class StargazersModel: StargazersModelProtocol {
    private let pagingModel: AnyPagingModel<GitHubUser>


    var didChange: RxCocoa.Driver<StargazersModelState> {
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
