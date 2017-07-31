import UIKit
import Result



/**
 A class for resources that require validations at runtime.
 This class provide bootstrap validations, so we should unwrap them
 at only App bootstrap.
 */
protocol BootstrapResourceRegistryContract {
    var font: FontRegistry { get }
}


struct FontRegistry {
    let octicons: UIFont
}



struct BootstrapResourceRegistry: BootstrapResourceRegistryContract {
    let font: FontRegistry


    static func create() -> Result<BootstrapResourceRegistry, BootstrapError> {
        do {
            try R.validate()
        }
        catch {
            return .failure(BootstrapError(resourceName: "R.generated.swift", debugInfo: "\(error)"))
        }

        guard let octicons = UIFont(name: "octicons", size: UIFont.systemFontSize) else {
            return .failure(BootstrapError(resourceName: "octicons.ttf", debugInfo: "Cannot instantiate"))
        }

        return .success(BootstrapResourceRegistry(
            font: FontRegistry(
                octicons: octicons
            )
        ))
    }


    struct BootstrapError: Error {
        let resourceName: String
        let debugInfo: String
    }
}



extension BootstrapResourceRegistry.BootstrapError: Equatable {
    static func == (_ lhs: BootstrapResourceRegistry.BootstrapError, _ rhs: BootstrapResourceRegistry.BootstrapError) -> Bool {
        return lhs.resourceName == rhs.resourceName
    }
}
