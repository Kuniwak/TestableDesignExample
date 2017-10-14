import XCTest
import UIKit
@testable import TestableDesignExample


class InfiniteScrollTriggerTests: XCTestCase {
    private struct TestCase {
        let threshold: CGFloat
        let scrollView: CGSize
        let contentView: CGSize
        let contentOffset: CGPoint
        let expected: Bool
    }


    func testShouldLoad() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                threshold: 100,
                scrollView: CGSize(width: 100, height: 200),
                contentView: CGSize(width: 100, height: 400),
                contentOffset: CGPoint(x: 0, y: 0),
                expected: false
            ),

            #line: TestCase(
                threshold: 100,
                scrollView: CGSize(width: 100, height: 200),
                contentView: CGSize(width: 100, height: 400),
                contentOffset: CGPoint(x: 0, y: 300),
                expected: true
            ),
        ]


        testCases.forEach { entry in
            let (line, testCase) = entry

            let trigger = InfiniteScrollThresholdTrigger(
                basedOn: testCase.threshold
            )

            let actual = trigger.shouldLoadY(
                contentOffset: testCase.contentOffset,
                contentSize: testCase.contentView,
                scrollViewSize: testCase.scrollView
            )

            XCTAssertEqual(actual, testCase.expected, line: line)
        }
    }
}

