import UIKit
import RxSwift
import RxCocoa



protocol ExampleValidationViewBindingProtocol {}



class ExampleValidationViewBinding: ExampleValidationViewBindingProtocol {
    private let disposeBag = RxSwift.DisposeBag()
    private let model: ExampleValidationModelProtocol
    private let view: ExampleValidationScreenRootView


    init(
        observing model: ExampleValidationModelProtocol,
        handling view: ExampleValidationScreenRootView
    ) {
        self.model = model
        self.view = view

        self.model.didChange
            .drive(onNext: { [weak self] state in
                guard let this = self else { return }

                switch state {
                case .notValidatedYet:
                    this.view.userNameHintLabel.text = ""
                    this.view.userNameHintLabel.backgroundColor = ColorPalette.Form.Background.normal
                    this.view.passwordHintLabel.text = ""
                    this.view.passwordHintLabel.backgroundColor = ColorPalette.Form.Background.normal

                case .validated(.success):
                    this.view.userNameHintLabel.text = ""
                    this.view.userNameHintLabel.backgroundColor = ColorPalette.Form.Background.ok
                    this.view.passwordHintLabel.text = ""
                    this.view.passwordHintLabel.backgroundColor = ColorPalette.Form.Background.ok

                case .validated(.failure(because: let reason)):
                    if let userNameReason = reason.userName.sorted().first {
                        let userNameHint: String
                        switch userNameReason {
                        case .shorterThan4:
                            userNameHint = "Must be longer than 8"
                        case .longerThan30:
                            userNameHint = "Must be shorter than 100"
                        case .hasUnavailableChars(found: let characters):
                            userNameHint = "Unavailable characters: \(string(from: characters))"
                        }
                        this.view.userNameHintLabel.text = userNameHint
                        this.view.userNameHintLabel.backgroundColor = ColorPalette.Form.Background.ng
                    }
                    else {
                        this.view.userNameHintLabel.text = ""
                        this.view.userNameHintLabel.backgroundColor = ColorPalette.Form.Background.ok
                    }

                    if let passwordReason = reason.password.sorted().first {
                        let passwordHint: String
                        switch passwordReason {
                        case .shorterThan8:
                            passwordHint = "Must be longer than 8"
                        case .longerThan100:
                            passwordHint = "Must be shorter than 100"
                        case .hasUnavailableChars(found: let characters):
                            passwordHint = "Unavailable characters: \(string(from: characters))"
                        case .sameAsUserName:
                            passwordHint = "Must be difference the user name"
                        }
                        this.view.passwordHintLabel.text = passwordHint
                        this.view.passwordHintLabel.backgroundColor = ColorPalette.Form.Background.ng
                    }
                    else {
                        this.view.passwordHintLabel.text = ""
                        this.view.passwordHintLabel.backgroundColor = ColorPalette.Form.Background.ok
                    }
                }
            })
            .disposed(by: self.disposeBag)
    }
}