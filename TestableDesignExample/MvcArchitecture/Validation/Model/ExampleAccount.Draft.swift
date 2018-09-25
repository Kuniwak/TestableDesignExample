extension ExampleAccount {
    struct Draft {
        let userName: String
        let password: String


        static func createEmpty() -> Draft {
            return Draft(userName: "", password: "")
        }
    }
}