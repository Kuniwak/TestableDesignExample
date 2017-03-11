import XCTest
import Result
@testable import TestableDesignExample



class BootstrapResourceRegistryTests: XCTestCase {
    func testCreate() {
        let registry = try! BootstrapResourceRegistry.create()
            .dematerialize()
        XCTAssertNotNil(registry)
    }


    static var allTests : [(String, (BootstrapResourceRegistryTests) -> () throws -> Void)] {
        return [
             ("testCreate", self.testCreate),
        ]
    }
}