enum ValidationResult<V, E> {
    case success(V)
    case failure(because: E)


    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }


    var value: V? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }


    var reason: E? {
        switch self {
        case .success:
            return nil
        case .failure(because: let reason):
            return reason
        }
    }
}



extension ValidationResult: Equatable where V: Equatable, E: Equatable {
    static func ==(lhs: ValidationResult<V, E>, rhs: ValidationResult<V, E>) -> Bool {
        switch (lhs, rhs) {
        case (.success(let l), .success(let r)):
            return l == r
        case (.failure(because: let l), .failure(because: let r)):
            return l == r
        default:
            return false
        }
    }
}