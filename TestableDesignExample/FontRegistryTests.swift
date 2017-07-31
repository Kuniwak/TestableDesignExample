import XCTest
@testable import TestableDesignExample


class FontRegistryTests: XCTestCase {
    func testFontIsNotNil() {
        XCTAssertNotNil(FontRegistry.octicons)
    }


    static var allTests: [(String, (FontRegistryTests) -> () throws -> Void)] {
        return [
            ("testFontIsNotNil", self.testFontIsNotNil),
        ]
    }
}

