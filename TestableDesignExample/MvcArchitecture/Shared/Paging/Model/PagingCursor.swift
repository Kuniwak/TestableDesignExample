protocol PagingCursorProtocol {
    var nextPage: Int { get }
    var previousPage: Int { get }

    func reset()
    func fetchingNextPageDidSucceed(isPageEnd: Bool)
    func fetchingPreviousPageDidSucceed(isPageEnd: Bool)
}



extension PagingCursorProtocol {
    func getPageNumber(of direction: PageEndDirection) -> Int {
        switch direction {
        case .previous:
            return self.previousPage
        case .next:
            return self.nextPage
        }
    }


    func fetchingDidSucceed(for direction: PageEndDirection, isPageEnd: Bool) {
        switch direction {
        case .previous:
            self.fetchingPreviousPageDidSucceed(isPageEnd: isPageEnd)
        case .next:
            self.fetchingNextPageDidSucceed(isPageEnd: isPageEnd)
        }
    }
}



class PagingCursor: PagingCursorProtocol {
    private(set) var nextPage: Int
    private(set) var previousPage: Int


    typealias Domain = (upperBound: Int, lowerBound: Int)
    private let domain: Domain
    private let initialNextPage = 1
    private let initialPreviousPage = 1


    init(whereMovingOn domain: Domain) {
        self.domain = domain
        self.nextPage = self.initialNextPage
        self.previousPage = self.initialPreviousPage
    }


    func reset() {
        self.nextPage = self.initialNextPage
        self.previousPage = self.initialPreviousPage
    }


    func fetchingNextPageDidSucceed(isPageEnd: Bool) {
        let isReachingDomainBound = self.domain.upperBound <= self.nextPage

        if isPageEnd || isReachingDomainBound {
            return
        }

        self.nextPage += 1
    }


    func fetchingPreviousPageDidSucceed(isPageEnd: Bool) {
        let isReachingDomainBound = self.domain.lowerBound >= self.nextPage

        if isPageEnd || isReachingDomainBound {
            return
        }

        self.previousPage -= 1
    }


    static let standardDomain: Domain = (
        upperBound: Int.max,
        lowerBound: 1
    )
}
