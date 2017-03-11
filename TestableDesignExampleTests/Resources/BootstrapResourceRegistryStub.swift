import UIKit
import Result
@testable import TestableDesignExample



struct BootstrapResourceRegistryStubFactory {
    static func create() -> BootstrapResourceRegistryContract {
        return try! BootstrapResourceRegistry.create()
            .dematerialize()
    }
}