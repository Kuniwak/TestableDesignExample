import Foundation



extension ExampleAccount.Draft {
    static func validate(draft: ExampleAccount.Draft) -> ValidationResult<ExampleAccount, InvalidReason> {
        let userNameResult = ExampleAccount.UserName.validate(userName: draft.userName)
        let passwordResult = ExampleAccount.Password.validate(password: draft.password, userName: draft.userName)

        switch (userNameResult, passwordResult) {
        case (.success(let userName), .success(let password)):
            return .success(ExampleAccount(
                userName: userName,
                password: password
            ))

        case (.failure(because: let userNameReason), .success):
            return .failure(because: InvalidReason(
                userName: userNameReason,
                password: []
            ))

        case (.success, .failure(because: let passwordReason)):
            return .failure(because: InvalidReason(
                userName: [],
                password: passwordReason
            ))

        case (.failure(because: let userNameReason), .failure(because: let passwordReason)):
            return .failure(because: InvalidReason(
                userName: userNameReason,
                password: passwordReason
            ))
        }
    }


    struct InvalidReason: Hashable {
        let userName: Set<ExampleAccount.UserName.InvalidReason>
        let password: Set<ExampleAccount.Password.InvalidReason>
    }
}


extension ExampleAccount.UserName {
    private static let acceptableCharacters = CharacterSet.letters


    static func validate(userName: String) -> ValidationResult<ExampleAccount.UserName, Set<InvalidReason>> {
        var reasons = Set<InvalidReason>()

        if userName.count < 4 {
            reasons.insert(.shorterThan4)
        }

        if userName.count > 30 {
            reasons.insert(.longerThan30)
        }

        let invalidChars = characters(in: userName, without: asciiAlphaNumeric)
        if !invalidChars.isEmpty {
            reasons.insert(.hasUnavailableChars(found: invalidChars))
        }

        guard reasons.isEmpty else {
            return .failure(because: reasons)
        }

        return .success(ExampleAccount.UserName(text: userName))
    }


    enum InvalidReason: Hashable, Comparable {
        case shorterThan4
        case longerThan30
        case hasUnavailableChars(found: Set<Character>)


        static func <(lhs: InvalidReason, rhs: InvalidReason) -> Bool {
            switch (lhs, rhs) {
            case (_, .shorterThan4):
                return false
            case (.shorterThan4, _):
                return true
            case (_, .longerThan30):
                return false
            case (.longerThan30, _):
                return true
            case (_, .hasUnavailableChars):
                return false
            case (.hasUnavailableChars, _):
                return true
            }
        }
    }
}


extension ExampleAccount.Password {
    static func validate(password: String, userName: String) -> ValidationResult<ExampleAccount.Password, Set<InvalidReason>> {
        var reasons = Set<InvalidReason>()

        if password.count < 8 {
            reasons.insert(.shorterThan8)
        }

        if password.count > 100 {
            reasons.insert(.longerThan100)
        }

        if password == userName {
            reasons.insert(.sameAsUserName)
        }

        let invalidChars = characters(in: password, without: asciiPrintable)
        if !invalidChars.isEmpty {
            reasons.insert(.hasUnavailableChars(found: invalidChars))
        }

        guard reasons.isEmpty else {
            return .failure(because: reasons)
        }

        return .success(ExampleAccount.Password(text: password))
    }


    enum InvalidReason: Hashable, Comparable {
        case shorterThan8
        case longerThan100
        case hasUnavailableChars(found: Set<Character>)
        case sameAsUserName


        static func <(lhs: InvalidReason, rhs: InvalidReason) -> Bool {
            switch (lhs, rhs) {
            case (_, .shorterThan8):
                return false
            case (.shorterThan8, _):
                return true
            case (_, .longerThan100):
                return false
            case (.longerThan100, _):
                return true
            case (_, .hasUnavailableChars):
                return false
            case (.hasUnavailableChars, _):
                return true
            case (_, .sameAsUserName):
                return false
            case (.sameAsUserName, _):
                return true
            }
        }
    }
}