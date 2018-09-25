import RxCocoa



protocol ExampleValidationModelProtocol {
    var currentState: ExampleValidationModelState { get }
    var didChange: RxCocoa.Driver<ExampleValidationModelState> { get }

    func update(by draft: ExampleAccount.Draft)
}



enum ExampleValidationModelState: Equatable {
    case notValidatedYet
    case validated(ValidationResult<ExampleAccount, ExampleAccount.Draft.InvalidReason>)
}



class ExampleValidationModel: ExampleValidationModelProtocol {
    typealias Strategy = (ExampleAccount.Draft) -> ValidationResult<ExampleAccount, ExampleAccount.Draft.InvalidReason>


    private let stateMachine: StateMachine<ExampleValidationModelState>
    private let validate: Strategy


    var currentState: ExampleValidationModelState {
        return self.stateMachine.currentState
    }


    var didChange: Driver<ExampleValidationModelState> {
        return self.stateMachine.didChange
    }


    init(startingWith initialState: ExampleValidationModelState, validatingBy strategy: @escaping Strategy) {
        self.stateMachine = StateMachine(startingWith: initialState)
        self.validate = strategy
    }


    func update(by draft: ExampleAccount.Draft) {
        let result = self.validate(draft)
        self.stateMachine.transit(to: .validated(result))
    }
}