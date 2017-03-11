import UIKit
import Result



protocol BootstrapResourceRegistryContract {
    var font: FontRegistry { get }
    var gitHubApiUrl: URL { get }
}


struct FontRegistry {
    let octicons: UIFont
}



struct BootstrapResourceRegistry: BootstrapResourceRegistryContract {
    let font: FontRegistry
    let gitHubApiUrl: URL


    init(font: FontRegistry, gitHubApiUrl: URL) {
        self.font = font
        self.gitHubApiUrl = gitHubApiUrl
    }


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

        guard let gitHubApiUrl = URL(string: "https://api.github.com/v3/") else {
            return .failure(BootstrapError(resourceName: "GitHub API URL", debugInfo: "Cannot instantiate"))
        }

        return .success(BootstrapResourceRegistry(
            font: FontRegistry(
                octicons: octicons
            ),
            gitHubApiUrl: gitHubApiUrl
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
