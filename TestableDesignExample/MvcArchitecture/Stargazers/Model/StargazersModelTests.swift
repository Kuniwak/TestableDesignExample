import XCTest
import PromiseKit
import MirrorDiffKit
import RxSwift
import RxBlocking
@testable import TestableDesignExample


class StarredRepositoriesModelTests: XCTestCase {
    private struct TestCase {
        let scenario: () -> StargazersModel
        let expected: StargazersModelState
    }


    private let gitHubRepository = GitHubRepository(
        owner: GitHubUser.Name(text: "octocat"),
        name: GitHubRepository.Name(text: "Hello-world")
    )


    func testScenarios() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                scenario: {
                    return StargazersModel.create(
                        requestingElementCountPerPage: 3,
                        fetchingPageVia: self.createPendingRepository()
                    )
                },
                expected: .fetched(stargazers: [], error: nil)
            ),


            #line: TestCase(
                scenario: {
                    let repository = StargazersRepositoryStub(
                        firstResult: Promise(value: [
                            GitHubUser(
                                id: GitHubUser.Id(text: "1"),
                                name: GitHubUser.Name(text: "stargazer-1"),
                                avatar: URL(string: "http://example.com/avatar-1.png")!
                            ),
                            GitHubUser(
                                id: GitHubUser.Id(text: "2"),
                                name: GitHubUser.Name(text: "stargazer-2"),
                                avatar: URL(string: "http://example.com/avatar-2.png")!
                            ),
                            GitHubUser(
                                id: GitHubUser.Id(text: "3"),
                                name: GitHubUser.Name(text: "stargazer-3"),
                                avatar: URL(string: "http://example.com/avatar-3.png")!
                            ),
                        ])
                    )

                    let model = StargazersModel.create(
                        requestingElementCountPerPage: 3,
                        fetchingPageVia: repository
                    )
                    model.fetchNext()
                    self.waitUntilFetched(model)

                    return model
                },
                expected: .fetched(
                    stargazers: [
                        GitHubUser(
                            id: GitHubUser.Id(text: "1"),
                            name: GitHubUser.Name(text: "stargazer-1"),
                            avatar: URL(string: "http://example.com/avatar-1.png")!
                        ),
                        GitHubUser(
                            id: GitHubUser.Id(text: "2"),
                            name: GitHubUser.Name(text: "stargazer-2"),
                            avatar: URL(string: "http://example.com/avatar-2.png")!
                        ),
                        GitHubUser(
                            id: GitHubUser.Id(text: "3"),
                            name: GitHubUser.Name(text: "stargazer-3"),
                            avatar: URL(string: "http://example.com/avatar-3.png")!
                        ),
                    ],
                    error: nil
                )
            ),


            #line: {
                return TestCase(
                    scenario: {
                        let repository = StargazersRepositoryStub(
                            firstResult: Promise(error: AnyError(debugInfo: "API call was failed"))
                        )

                        let model = StargazersModel.create(
                            requestingElementCountPerPage: 3,
                            fetchingPageVia: repository
                        )
                        model.fetchNext()
                        self.waitUntilFetched(model)

                        return model
                    },
                    expected: .fetched(
                        stargazers: [],
                        error: .apiError(debugInfo: "any error")
                    )
                )
            }(),


            #line: TestCase(
                scenario: {
                    let repository = StargazersRepositoryStub(
                        firstResult: Promise(error: AnyError(debugInfo: "API call was failed"))
                    )

                    let model = StargazersModel.create(
                        requestingElementCountPerPage: 1,
                        fetchingPageVia: repository
                    )
                    model.fetchNext()
                    self.waitUntilFetched(model)

                    repository.nextResult = Promise(value: [GitHubUser]())

                    model.fetchNext()
                    self.waitUntilFetched(model)

                    return model
                },
                expected: .fetched(
                    stargazers: [],
                    error: nil
                )
            ),


            #line: TestCase(
                scenario: {
                    let repository = StargazersRepositoryStub(
                        firstResult: Promise(value: [
                            GitHubUser(
                                id: GitHubUser.Id(text: "1234"),
                                name: GitHubUser.Name(text: "user-new"),
                                avatar: URL(string: "http://example.com/user-new.png")!
                            ),
                        ])
                    )

                    let model = StargazersModel.create(
                        requestingElementCountPerPage: 1,
                        fetchingPageVia: repository
                    )
                    model.fetchNext()
                    self.waitUntilFetched(model)

                    repository.nextResult = Promise(value: [
                        GitHubUser(
                            id: GitHubUser.Id(text: "1234"),
                            name: GitHubUser.Name(text: "user-new"),
                            avatar: URL(string: "http://example.com/user-new.png")!
                        )
                    ])

                    model.fetchNext()
                    self.waitUntilFetching(model)
                    self.waitUntilFetched(model)

                    return model
                },
                expected: .fetched(
                    stargazers: [
                        GitHubUser(
                            id: GitHubUser.Id(text: "1234"),
                            name: GitHubUser.Name(text: "user-new"),
                            avatar: URL(string: "http://example.com/user-new.png")!
                        ),
                    ],
                    error: nil
                )
            ),
        ]


        testCases.forEach { (line, testCase) in
            let model = testCase.scenario()

            XCTAssert(
                model.currentState == testCase.expected,
                diff(between: testCase.expected, and: model.currentState),
                line: line
            )
        }
    }



    private func waitUntilFetching(_ model: StargazersModel) {
        _ = try! model.didChange
            .filter { state in self.isFetching(state) }
            .asObservable()
            .take(1)
            .toBlocking()
            .last()
    }



    private func waitUntilFetched(_ model: StargazersModel) {
        _ = try! model.didChange
            .asObservable()
            .filter { state in self.isFetched(state) }
            .take(1)
            .toBlocking()
            .last()
    }



    private func isFetched(_ state: StargazersModelState) -> Bool {
        switch state {
        case .fetched:
            return true
        default:
            return false
        }
    }



    private func isFetching(_ state: StargazersModelState) -> Bool {
        switch state {
        case .fetching:
            return true
        default:
            return false
        }
    }


    private func createPendingRepository() -> StargazersRepositoryStub {
        return StargazersRepositoryStub(
            firstResult: Promise<[GitHubUser]>.pending().promise
        )
    }



    static var allTests : [(String, (StarredRepositoriesModelTests) -> () throws -> Void)] {
        return [
             ("testScenarios", self.testScenarios),
        ]
    }
}
