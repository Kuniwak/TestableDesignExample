NOTE
====

Test files are placed nearby the test target.
For example, if a test target is `Foo.swift`, the test file `FooTests.swift` is placed on the same directory of the target.

But the directory `TestableDesignExampleTests` has test helpers.


Test Helpers
============

Promisified Asynchronous Test Helper
------------------------------------

Promise is a design pattern of asynchronous processing.
This patterns is heavily used by JavaScript.

The `Promise` has a three states; Pending, Fulfilled, Rejected.
Penging is a state that means that "the result is not ready yet".
Fulfilled means that "the result is ready", and Rejected means "an error was occured while processing".
See then [the official tutorial](https://github.com/mxcl/PromiseKit/blob/master/Documentation/CommonPatterns.md) for more information.

The Promise pattern is familiar to asynchronous testing.
In JavaScript, Mocha is the most famous testing library adopt a Promise-based teeting.
In Swift, [PromiseKit](https://github.com/mxcl/PromiseKit) is a Promise library is available, but this library is not supported asynchronous testing.
So, we implement a test helper for asynchronous testing as follow:

```swift
class FooTests: XCTestCase {
    func testExample() {
        async(test: self, line: #line) {
            // This test await the returned promise is fulfilled or rejected.
            return somethingReturnPromsie()
                .then { foo in
                    XCTAssertEqual(foo, "foo")
                }
        }
    }
}
```

The implementation of the test helper is below:

```swift
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
```
