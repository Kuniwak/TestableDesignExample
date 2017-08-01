import XCTest
@testable import TestableDesignExample


class PagingCursorTests: XCTestCase {
    private struct TestCase {
        let scenario: [Command]
        let expected: (nextPage: Int, previousPage: Int)


        enum Command {
            case fetchNext(isPageEnd: Bool)
            case fetchPrevious(isPageEnd: Bool)

            func perform(on cursor: PagingCursorContract) {
                switch self {
                case let .fetchNext(isPageEnd: isPageEnd):
                    cursor.fetchingNextPageDidSucceed(isPageEnd: isPageEnd)
                case let .fetchPrevious(isPageEnd: isPageEnd):
                    cursor.fetchingPreviousPageDidSucceed(isPageEnd: isPageEnd)
                }
            }
        }
    }



    func testScenarios() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                scenario: [],
                expected: (
                    nextPage: 1,
                    previousPage: 1
                )
            ),

            #line: TestCase(
                scenario: [
                    .fetchPrevious(isPageEnd: false),
                ],
                expected: (
                    nextPage: 1,
                    previousPage: 1
                )
            ),

            #line: TestCase(
                scenario: [
                    .fetchPrevious(isPageEnd: true),
                ],
                expected: (
                    nextPage: 1,
                    previousPage: 1
                )
            ),

            #line: TestCase(
                scenario: [
                    .fetchNext(isPageEnd: false),
                ],
                expected: (
                    nextPage: 2,
                    previousPage: 1
                )
            ),

            #line: TestCase(
                scenario: [
                    .fetchNext(isPageEnd: true),
                ],
                expected: (
                    nextPage: 1,
                    previousPage: 1
                )
            ),

            #line: TestCase(
                scenario: [
                    .fetchNext(isPageEnd: true),
                    .fetchNext(isPageEnd: true),
                ],
                expected: (
                    nextPage: 1,
                    previousPage: 1
                )
            ),

            #line: TestCase(
                scenario: [
                    .fetchNext(isPageEnd: false),
                    .fetchNext(isPageEnd: true),
                ],
                expected: (
                    nextPage: 2,
                    previousPage: 1
                )
            ),

            #line: TestCase(
                scenario: [
                    .fetchNext(isPageEnd: false),
                    .fetchNext(isPageEnd: false),
                ],
                expected: (
                    nextPage: 3,
                    previousPage: 1
                )
            ),

            #line: TestCase(
                scenario: [
                    .fetchNext(isPageEnd: true),
                    .fetchNext(isPageEnd: false),
                ],
                expected: (
                    nextPage: 2,
                    previousPage: 1
                )
            ),
        ]


        testCases.forEach { lineAndTestCase in
            let (line, testCase) = lineAndTestCase

            let cursor = PagingCursor(whereMovingOn: PagingCursor.standardDomain)

            testCase.scenario.forEach { command in
                command.perform(on: cursor)
            }

            XCTAssertEqual(
                testCase.expected.nextPage,
                cursor.nextPage,
                line: line
            )
            XCTAssertEqual(
                testCase.expected.previousPage,
                cursor.previousPage,
                line: line
            )
        }
    }



    static var allTests: [(String, (PagingCursorTests) -> () throws -> Void)] {
        return [
            ("testScenarios", self.testScenarios),
        ]
    }
}

