import UIKit
@testable import TestableDesignExample



class ReverseNavigatorSpy: ReverseNavigatorContract {
    typealias CallArgs = Bool
    fileprivate(set) var callArgs: [CallArgs] = []


    var stub: ReverseNavigatorContract


    init() {
        self.stub = ReverseNavigatorStub()
    }


    init(inheriting stub: ReverseNavigatorContract) {
        self.stub = stub
    }


    func back(animated: Bool) throws {
        self.callArgs.append(animated)
        try self.stub.back(animated: animated)
    }
}
