import UIKit
import enum Result.Result
import PromiseKit



protocol RootNavigatorProtocol {
    func navigateToRoot()
}



class RootNavigator: RootNavigatorProtocol {
    private let rootViewControllerHolder: RootViewControllerHolderProtocol


    init(using rootViewControllerHolder: RootViewControllerHolderProtocol) {
        self.rootViewControllerHolder = rootViewControllerHolder
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

        let stargazerModel = StargazerModel.create(
            requestingElementCountPerPage: PerformanceParameter.numberOfStargazersPerPage,
            fetchingPageVia: StargazerRepository(
                for: gitHubRepository,
                perPage: PerformanceParameter.numberOfStargazersPerPage,
                fetchingVia: api
            )
        )

        let composer = StargazersMvcComposer(
            for: gitHubRepository,
            representing: stargazerModel,
            navigatingBy: navigator,
            holding: bag
        )

        navigationController.setViewControllers(
            [composer],
            animated: true
        )

        self.rootViewControllerHolder.alter(to: navigationController)
    }
}
