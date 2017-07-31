import UIKit
import enum Result.Result
import PromiseKit



protocol RootNavigatorContract {
    func navigateToRoot()
}



class RootNavigator: RootNavigatorContract {
    private let window: UIWindow


    init(willUpdate window: UIWindow) {
        self.window = window
    }


    func navigateToRoot() {
        let navigationController = NavigationController()
        let navigator = Navigator(for: navigationController)

        let repository = GitHubRepository(
            owner: GitHubUser.Name(text: "Kuniwak"),
            name: GitHubRepository.Name(text: "MirrorDiffKit")
        )

        let api = GitHubApiClient(basedOn: GitHubApiEndpointBaseUrl.gitHubCom)

        guard let rootViewController = StargazersMvcComposer.create(
            byStargazersOf: repository,
            andFetchingVia: api,
            andNavigateBy: navigator
        ) else {
            self.window.rootViewController = FatalErrorViewController.create(
                debugInfo: "StarredRepositoriesViewController.create returned nil"
            )
            return
        }

        navigationController.setViewControllers([rootViewController], animated: true)

        self.window.rootViewController = navigationController
    }
}
