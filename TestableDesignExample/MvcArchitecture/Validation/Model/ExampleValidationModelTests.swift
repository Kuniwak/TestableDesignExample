import XCTest
import MirrorDiffKit
@testable import TestableDesignExample



class ExampleValidationModelTests: XCTestCase {
    func testNotValidatedYet() {
        let model = ExampleValidationModel(
            startingWith: .notValidatedYet,
            validatingBy: self.createDummyStrategy()
        )

        let actual = model.currentState

        let expected: ExampleValidationModelState = .notValidatedYet
        XCTAssertEqual(actual, expected, diff(between: expected, and: actual))
    }


    func testSuccess() {
        let account = ExampleAccountFactory.create()
        let model = ExampleValidationModel(
            startingWith: .notValidatedYet,
            validatingBy: self.createSuccessfulStrategy(account: account)
        )

        let anyDraft = ExampleAccountFactory.DraftFactory.create()
        model.update(by: anyDraft)

        let actual = model.currentState
        let expected: ExampleValidationModelState = .validated(.success(account))
        XCTAssertEqual(actual, expected, diff(between: expected, and: actual))
    }


    func testFailure() {
        let reason = self.createAnyDraftInvalidReasonSet()
        let model = ExampleValidationModel(
            startingWith: .notValidatedYet,
            validatingBy: self.createFailedStrategy(reason: reason)
        )

        let anyDraft = ExampleAccountFactory.DraftFactory.create()
        model.update(by: anyDraft)

        let actual = model.currentState
        let expected: ExampleValidationModelState = .validated(.failure(because: reason))
        XCTAssertEqual(actual, expected, diff(between: expected, and: actual))
    }


    private func createDummyStrategy() -> ExampleValidationModel.Strategy {
        return { _ in
            fatalError("It should not affect to test results")
        }
    }


    private func createSuccessfulStrategy(account: ExampleAccount) -> ExampleValidationModel.Strategy {
        return { _ in
            return .success(account)
        }
    }


    private func createFailedStrategy(reason: ExampleAccount.Draft.InvalidReason) -> ExampleValidationModel.Strategy {
        return { _ in
            return .failure(because: reason)
        }
    }


    private func createAnyDraftInvalidReasonSet() -> ExampleAccount.Draft.InvalidReason {
        return ExampleAccount.Draft.InvalidReason(
            userName: [.shorterThan4],
            password: [.shorterThan8]
        )
    }
}