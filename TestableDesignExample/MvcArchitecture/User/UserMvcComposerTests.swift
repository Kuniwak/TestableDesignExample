import XCTest
@testable import TestableDesignExample


class UserMvcComposerTests: XCTestCase {
    func testCreate() {
        let testNavigator = TestNavigator(line: #line)

        let viewController = UserMvcComposer.create(
            for: GitHubUser(
                name: GitHubUser.Name(text: "octocat"),
                avatar: URL(string: "https://avatars3.githubusercontent.com/u/583231?v=3&s=400")!
            )
        )

        testNavigator.navigateWithFallback(to: viewController)
    }


    static var allTests : [(String, (UserMvcComposerTests) -> () throws -> Void)] {
        return [
             ("testCreate", self.testCreate),
        ]
    }
}