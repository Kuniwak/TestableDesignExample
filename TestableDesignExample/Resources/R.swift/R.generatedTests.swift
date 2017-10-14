import XCTest
@testable import TestableDesignExample


class R_generatedTests: XCTestCase {
    func testValidate() throws {
        try TestableDesignExample.R.validate()
    }


    func testValidateForTest() throws {
        try R.validate()
    }


    static var allTests: [(String, (R_generatedTests) -> () throws -> Void)] {
        return [
            ("testValidate", self.testValidate),
            ("testValidateForTest", self.testValidateForTest),
        ]
    }
}

