@testable import TestableDesignExample



enum ExampleAccountFactory {
    static func create(
        userName: ExampleAccount.UserName = UserNameFactory.create(),
        password: ExampleAccount.Password = PasswordFactory.create()
    ) -> ExampleAccount {
        return ExampleAccount(userName: userName, password: password)
    }


    enum UserNameFactory {
        static func create(text: String = "userName") -> ExampleAccount.UserName {
            return .init(text: text)
        }
    }


    enum PasswordFactory {
        static func create(text: String = "userName") -> ExampleAccount.Password {
            return .init(text: text)
        }
    }


    enum DraftFactory {
        static func create(userName: String = "", password: String = "") -> ExampleAccount.Draft {
            return ExampleAccount.Draft(userName: userName, password: password)
        }
    }
}
