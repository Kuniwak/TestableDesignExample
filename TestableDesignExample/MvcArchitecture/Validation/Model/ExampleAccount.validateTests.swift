import XCTest
import MirrorDiffKit
@testable import TestableDesignExample



class ExampleAccountTests: XCTestCase {
    func testValidate() {
    	typealias TestCase = (
            input: ExampleAccount.Draft,
            expected: ValidationResult<ExampleAccount, ExampleAccount.Draft.InvalidReason>
    	)

    	let testCases: [UInt: TestCase] = [
            #line: (
                input: .init(
                    userName: "userName",
                    password: "password"
                ),
                expected: .success(ExampleAccount(
                    userName: .init(text: "userName"),
                    password: .init(text: "password")
                ))
            ),
            #line: (
                input: .init(
                    userName: "",
                    password: "password"
                ),
                expected: .failure(
                    because: .init(userName: [.shorterThan4], password: [])
                )
            ),
            #line: (
                input: .init(
                    userName: "userName",
                    password: ""
                ),
                expected: .failure(
                    because: .init(userName: [], password: [.shorterThan8])
                )
            ),
            #line: (
                input: .init(
                    userName: "u",
                    password: "p"
                ),
                expected: .failure(
                    because: .init(
                        userName: [.shorterThan4],
                        password: [.shorterThan8]
                    )
                )
            ),
            #line: (
                input: .init(
                    userName: "userName",
                    password: "userName"
                ),
                expected: .failure(
                    because: .init(
                        userName: [],
                        password: [.sameAsUserName]
                    )
                )
            ),
    	]

    	testCases.forEach { tuple in
    	    let (line, (input: draft, expected: expected)) = tuple

            let actual = ExampleAccount.Draft.validate(draft: draft)

            XCTAssertEqual(expected, actual, diff(between: actual, and: expected), line: line)
    	}
    }
}



class ExampleAccountUserNameTests: XCTestCase {
    func testValidate() {
    	typealias TestCase = (
			input: String,
			expected: ValidationResult<ExampleAccount.UserName, Set<ExampleAccount.UserName.InvalidReason>>
    	)

    	let testCases: [UInt: TestCase] = [
    	    #line: (
                input: "",
                expected: .failure(because: [.shorterThan4])
            ),
            #line: (
                input: String(repeating: "x", count: 3),
                expected: .failure(because: [.shorterThan4])
            ),
            #line: (
                input: String(repeating: "x", count: 4),
                expected: .success(.init(text: String(repeating: "x", count: 4)))
            ),
            #line: (
                input: String(repeating: "x", count: 30),
                expected: .success(.init(text: String(repeating: "x", count: 30)))
            ),
            #line: (
                input: String(repeating: "x", count: 31),
                expected: .failure(because: [.longerThan30])
            ),
            #line: (
                input: string(from: asciiDigit),
                expected: .success(.init(text: string(from: asciiDigit)))
            ),
            #line: (
                input: string(from: asciiLowerAlpha),
                expected: .success(.init(text: string(from: asciiLowerAlpha)))
            ),
            #line: (
                input: string(from: asciiUpperAlpha),
                expected: .success(.init(text: string(from: asciiUpperAlpha)))
            ),
            #line: (
                input: "abcd1234ABCD",
                expected: .success(.init(text: "abcd1234ABCD"))
            ),
            #line: (
                input: string(from: asciiSymbol),
                expected: .failure(because: [
                    .longerThan30,
                    .hasUnavailableChars(found: asciiSymbol),
                ])
            ),
    	]

    	testCases.forEach { tuple in
    	    let (line, (input: input, expected: expected)) = tuple

            let actual = ExampleAccount.UserName.validate(userName: input)

            XCTAssertEqual(expected, actual, diff(between: actual, and: expected), line: line)
    	}
    }
}



class ExampleAccountPasswordTests: XCTestCase {
    func testValidate() {
    	typealias TestCase = (
            input: (password: String, userName: String),
            expected: ValidationResult<ExampleAccount.Password, Set<ExampleAccount.Password.InvalidReason>>
        )

    	let testCases: [UInt: TestCase] = [
    	    #line: (
                input: (password: "", userName: "userName"),
                expected: .failure(because: [.shorterThan8])
            ),
            #line: (
                input: (password: String(repeating: "x", count: 7), userName: "userName"),
                expected: .failure(because: [.shorterThan8])
            ),
            #line: (
                input: (password: String(repeating: "x", count: 8), userName: "userName"),
                expected: .success(.init(text: String(repeating: "x", count: 8)))
            ),
            #line: (
                input: (password: String(repeating: "x", count: 100), userName: "userName"),
                expected: .success(.init(text: String(repeating: "x", count: 100)))
            ),
            #line: (
                input: (password: String(repeating: "x", count: 101), userName: "userName"),
                expected: .failure(because: [.longerThan100])
            ),
            #line: (
                input: (password: string(from: asciiPrintable), userName: "userName"),
                expected: .success(.init(text: string(from: asciiPrintable)))
            ),
            #line: (
                input: (password: "userName", userName: "userName"),
                expected: .failure(because: [.sameAsUserName])
            ),
    	]

    	testCases.forEach { tuple in
    	    let (line, (input: (password: password, userName: userName), expected: expected)) = tuple

            let actual = ExampleAccount.Password.validate(password: password, userName: userName)

            XCTAssertEqual(expected, actual, diff(between: actual, and: expected), line: line)
    	}
    }
}