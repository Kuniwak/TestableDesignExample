import XCTest
import TestableDesignExample


class Parallel2Test: XCTestCase {
    func test1Before2() {
        let deferred1 = Deferred<Int>()
        let deferred2 = Deferred<Int>()

        parallel(
            deferred1.listen,
            deferred2.listen,
            serialDispatcher: syncSerialDispatcher()
        ) { (x1, x2) in
            XCTAssertEqual(x1, 1)
            XCTAssertEqual(x2, 2)
        }

        deferred1.call(1)
        deferred2.call(2)
    }


    func test1After2() {
        let deferred1 = Deferred<Int>()
        let deferred2 = Deferred<Int>()

        parallel(
            deferred1.listen,
            deferred2.listen,
            serialDispatcher: syncSerialDispatcher()
        ) { (x1, x2) in
            XCTAssertEqual(x1, 1)
            XCTAssertEqual(x2, 2)
        }

        deferred2.call(2)
        deferred1.call(1)
    }


    func testNever1() {
        parallel(
            immediateResolver(with: 0),
            neverResolver(),
            serialDispatcher: syncSerialDispatcher()
        ) { (x1, x2) in
            XCTFail()
        }
    }


    func testNever2() {
        parallel(
            neverResolver(),
            immediateResolver(with: 1),
            serialDispatcher: syncSerialDispatcher()
        ) { (x1, x2) in
            XCTFail()
        }
    }
}


class Parallel3Test: XCTestCase {
    func test1Before2Before3() {
        let deferred1 = Deferred<Int>()
        let deferred2 = Deferred<Int>()
        let deferred3 = Deferred<Int>()

        parallel(
            deferred1.listen,
            deferred2.listen,
            deferred3.listen,
            serialDispatcher: syncSerialDispatcher()
        ) { (x1, x2, x3) in
            XCTAssertEqual(x1, 1)
            XCTAssertEqual(x2, 2)
            XCTAssertEqual(x3, 3)
        }

        deferred1.call(1)
        deferred2.call(2)
        deferred3.call(3)
    }


    func test1After2After3() {
        let deferred1 = Deferred<Int>()
        let deferred2 = Deferred<Int>()
        let deferred3 = Deferred<Int>()

        parallel(
            deferred1.listen,
            deferred2.listen,
            deferred3.listen,
            serialDispatcher: syncSerialDispatcher()
        ) { (x1, x2, x3) in
            XCTAssertEqual(x1, 1)
            XCTAssertEqual(x2, 2)
        }

        deferred3.call(3)
        deferred2.call(2)
        deferred1.call(1)
    }


    func test1After2Before3() {
        let deferred1 = Deferred<Int>()
        let deferred2 = Deferred<Int>()
        let deferred3 = Deferred<Int>()

        parallel(
            deferred1.listen,
            deferred2.listen,
            deferred3.listen,
            serialDispatcher: syncSerialDispatcher()
        ) { (x1, x2, x3) in
            XCTAssertEqual(x1, 1)
            XCTAssertEqual(x2, 2)
        }

        deferred2.call(2)
        deferred3.call(3)
        deferred1.call(1)
    }
}


class ParallelNTests: XCTestCase {
    func testForward() {
        let deferreds: [Deferred<Int>] = [
            Deferred(),
            Deferred(),
            Deferred(),
        ]

        let listeners = deferreds.map { $0.listen }

        parallel(listeners, serialDispatcher: syncSerialDispatcher()) { xs in
            XCTAssertEqual(xs, [0, 1, 2])
        }

        deferreds.enumerated().forEach { tuple in
            let (index, deferred) = tuple
            deferred.call(index)
        }
    }


    func testBackword() {
        let deferreds: [Deferred<Int>] = [
            Deferred(),
            Deferred(),
            Deferred(),
        ]

        let listeners = deferreds.map { $0.listen }

        parallel(listeners, serialDispatcher: syncSerialDispatcher()) { xs in
            XCTAssertEqual(xs, [0, 1, 2])
        }

        deferreds.enumerated().reversed().forEach { tuple in
            let (index, deferred) = tuple
            deferred.call(index)
        }
    }
}


class Deferred<T> {
    private var callback: ((T) -> Void)?


    func listen(callback: @escaping (T) -> Void) {
        self.callback = callback
    }


    func call(_ x: T) {
        self.callback!(x)
    }
}


func syncSerialDispatcher() -> SerialDispatcher {
    return { (callback: @escaping () -> Void) in
        callback()
    }
}


func immediateResolver<T>(with value: T) -> (@escaping (T) -> Void) -> Void {
    return { (callback: @escaping (T) -> Void) in
        callback(value)
    }
}


func neverResolver() -> (@escaping (()) -> Void) -> Void {
    return { _ in }
}