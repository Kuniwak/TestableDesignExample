struct ExampleAccount: Equatable {
    let userName: UserName
    let password: Password


    struct UserName: Equatable {
        let text: String
    }


    struct Password: Equatable {
        let text: String
    }
}