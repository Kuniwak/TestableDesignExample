import XCTest
@testable import TestableDesignExample


class UserMvcComposerTests: XCTestCase {
    func testCreate() {
        let testNavigator = TestNavigator(line: #line)

        let user = GitHubUser(
            id: GitHubUser.Id(text: "1"),
            name: GitHubUser.Name(text: "octocat"),
            avatar: URL(string: "https://avatars3.githubusercontent.com/u/583231?v=3&s=400")!
        )

        let viewController = UserMvcComposer.create(
            byModel: UserModelStub(
                withInitialState: .fetched(
                    result: .success(user)
                )
            )
        )

        testNavigator.navigateWithFallback(
            to: viewController,
            animated: false
        )
    }


    static var allTests : [(String, (UserMvcComposerTests) -> () throws -> Void)] {
        return [
             ("testCreate", self.testCreate),
        ]
    }
}