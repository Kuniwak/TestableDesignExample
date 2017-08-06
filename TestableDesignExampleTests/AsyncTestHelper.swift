import PromiseKit
import XCTest



func async(test: XCTestCase, timeout: TimeInterval = 1.0, line: UInt = #line, _ block: @escaping () -> Promise<Void>) {
    let expectation = test.expectation(description: "Promise is not fulfilled.")

    block()
        .then { _ in
            expectation.fulfill()
        }
        .catch { error in
            XCTFail("\(error)", line: line)
            expectation.fulfill()
        }

    test.waitForExpectations(timeout: timeout)
}