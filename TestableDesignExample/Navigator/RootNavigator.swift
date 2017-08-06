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
        let navigationController = UINavigationController()
        VisualDecorator.decorate(navigationBar: navigationController.navigationBar)

        let navigator = Navigator(for: navigationController)

        let gitHubRepository = GitHubRepository(
            owner: GitHubUser.Name(text: "Kuniwak"),
            name: GitHubRepository.Name(text: "MirrorDiffKit")
        )

        let api = GitHubApiClient(basedOn: GitHubApiEndpointBaseUrl.gitHubCom)
        let bag = Bag(api: api)

        let stargazerModel = StargazerModel(
            for: gitHubRepository,
            fetchingVia: StargazerRepository(api: api)
        )

        guard let rootViewController = StargazersMvcComposer.create(
            byStargazersOf: gitHubRepository,
            presenting: stargazerModel,
            navigatingBy: navigator,
            holding: bag
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
