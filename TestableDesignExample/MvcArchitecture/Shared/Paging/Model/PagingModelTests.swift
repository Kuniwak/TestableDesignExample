import XCTest
import RxSwift
import RxCocoa
import RxBlocking
import MirrorDiffKit
import PromiseKit
@testable import TestableDesignExample


class PagingModelTests: XCTestCase {
    func testInitialState() {
        let pagingModel = self.createPagingModel(
            fetchingPageVia: self.createPageRepositoryStub()
        )

        let actual = pagingModel.currentState
        let expected = PagingModelState.fetched(elements: [Element](), error: nil)

        XCTAssert(
            expected =~ actual,
            diff(between: expected, and: actual)
        )
    }


    func testStateAfterFetchNext() {
        let pagingModel = self.createPagingModel(
            fetchingPageVia: self.createPageRepositoryStub(),
            whereCursorMovingOn: 1..<Int.max
        )

        pagingModel.fetchNext()
        self.waitUntilFetched(pagingModel)

        let actual = pagingModel.currentState
        let expected = PagingModelState.fetched(elements: [
            Element(pageNumber: 1),
        ], error: nil)

        XCTAssert(
            expected =~ actual,
            diff(between: expected, and: actual)
        )
    }


    func testStateAfterFetchPrevious() {
        let pagingModel = self.createPagingModel(
            fetchingPageVia: self.createPageRepositoryStub(),
            whereCursorMovingOn: 1..<Int.max
        )

        pagingModel.fetchPrevious()
        self.waitUntilFetched(pagingModel)

        let actual = pagingModel.currentState
        let expected = PagingModelState.fetched(elements: [
            Element(pageNumber: 1),
        ], error: nil)

        XCTAssert(
            expected =~ actual,
            diff(between: expected, and: actual)
        )
    }


    func testStateAfterFetchNextTwice() {
        let pagingModel = self.createPagingModel(
            fetchingPageVia: self.createPageRepositoryStub(),
            whereCursorMovingOn: 1..<Int.max
        )

        pagingModel.fetchNext()
        self.waitUntilFetched(pagingModel)

        pagingModel.fetchNext()
        self.waitUntilFetched(pagingModel)

        let actual = pagingModel.currentState
        let expected = PagingModelState.fetched(elements: [
            Element(pageNumber: 1),
            Element(pageNumber: 2),
        ], error: nil)

        XCTAssert(
            expected =~ actual,
            diff(between: expected, and: actual)
        )
    }


    func testStateAfterFetchNextTwiceButReachedAtPageEnd() {
        let pagingModel = self.createPagingModel(
            fetchingPageVia: self.createPageRepositoryStub(),
            whereCursorMovingOn: 1..<1
        )

        pagingModel.fetchNext()
        self.waitUntilFetched(pagingModel)

        pagingModel.fetchNext()
        self.waitUntilFetched(pagingModel)

        let actual = pagingModel.currentState
        let expected = PagingModelState.fetched(elements: [
            Element(pageNumber: 1),
        ], error: nil)

        XCTAssert(
            expected =~ actual,
            diff(between: expected, and: actual)
        )
    }


    func testStateAfterFetchNext3TimesButReachedAtPageEnd() {
        let pagingModel = self.createPagingModel(
            fetchingPageVia: self.createPageRepositoryStub(),
            whereCursorMovingOn: 1..<2
        )

        pagingModel.fetchNext()
        self.waitUntilFetched(pagingModel)

        pagingModel.fetchNext()
        self.waitUntilFetched(pagingModel)

        pagingModel.fetchNext()
        self.waitUntilFetched(pagingModel)

        let actual = pagingModel.currentState
        let expected = PagingModelState.fetched(elements: [
            Element(pageNumber: 1),
            Element(pageNumber: 2),
        ], error: nil)

        XCTAssert(
            expected =~ actual,
            diff(between: expected, and: actual)
        )
    }


    func testStateAfterFetchPreviousTwice() {
        let pagingModel = self.createPagingModel(
            fetchingPageVia: self.createPageRepositoryStub(),
            whereCursorMovingOn: 1..<Int.max
        )

        pagingModel.fetchPrevious()
        self.waitUntilFetched(pagingModel)

        pagingModel.fetchPrevious()
        self.waitUntilFetched(pagingModel)

        let actual = pagingModel.currentState
        let expected = PagingModelState.fetched(elements: [
            Element(pageNumber: 1),
        ], error: nil)

        XCTAssert(
            expected =~ actual,
            diff(between: expected, and: actual)
        )
    }


    private func createPagingModel<PageRepository: PageRepositoryProtocol>(
        fetchingPageVia pageRepository: PageRepository,
        whereCursorMovingOn range: Range<Int> = 1..<Int.max
    ) -> PagingModel<Element> where PageRepository.Element == Element {
        return PagingModel(
            fetchingPageVia: pageRepository,
            detectingPageEndBy: PageEndDetectionStrategyStub(
                whereCursorMovingOn: range
            ),
            choosingPageNumberBy: PagingCursor(
                whereMovingOn: PagingCursor.standardDomain
            )
        )
    }


    private func createPageRepositoryStub() -> PageRepositoryStub<Element> {
        return PageRepositoryStub(
            willReturn: { pageNumber in
                return Promise(value: [
                    Element(pageNumber: pageNumber),
                ])
            }
        )
    }


    private func waitUntilFetched(_ pagingModel: PagingModel<Element>) {
        _ = try! pagingModel
            .didChange
            .asObservable()
            .filter { state in
                switch state {
                case .fetching:
                    return false
                case .fetched:
                    return true
                }
            }
            .take(1)
            .toBlocking()
            .first()
    }


    private struct Element: Hashable {
        let pageNumber: Int


        var hashValue: Int {
            return self.pageNumber
        }


        public static func ==(lhs: Element, rhs: Element) -> Bool {
            return lhs.pageNumber == rhs.pageNumber
        }
    }
}

