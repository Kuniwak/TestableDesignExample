import Dispatch


private indirect enum ParallelIntermediate<T1, T2> {
    case none
    case f1Completed(T1)
    case f2Completed(T2)
}


public typealias SerialDispatcher = (@escaping () -> Void) -> Void


public func asyncSerialDispatcher(qos: DispatchQoS.QoSClass = .default) -> SerialDispatcher {
    return { (callback: @escaping () -> Void) in
        DispatchQueue.global(qos: qos).async(execute: callback)
    }
}


public enum DispatchQueueStrategy {
    public static let `default` = { (callback: @escaping () -> Void) in
        DispatchQueue.global().async(execute: callback)
    }
}


public func parallel<T1, T2>(
    _ f1: @escaping (@escaping (T1) -> Void) -> Void,
    _ f2: @escaping (@escaping (T2) -> Void) -> Void,
    serialDispatcher: @escaping SerialDispatcher = asyncSerialDispatcher(),
    debugInfo: (file: String, line: UInt) = (file: #file, line: #line),
    _ callback: @escaping (T1, T2) -> Void
) {
    var intermediate: ParallelIntermediate<T1, T2> = .none

    f1 { (x1: T1) in
        serialDispatcher {
            switch intermediate {
            case .none:
                intermediate = .f1Completed(x1)
            case .f1Completed:
                print("WARNING: the 1st argument of parallel was called more than once via \(debugInfo.file) at \(debugInfo.line).")
            case .f2Completed(let x2):
                callback(x1, x2)
            }
        }
    }

    f2 { (x2: T2) in
        serialDispatcher {
            switch intermediate {
            case .none:
                intermediate = .f2Completed(x2)
            case .f1Completed(let x1):
                callback(x1, x2)
            case .f2Completed:
                print(
                    "WARNING: the 2nd argument of parallel was called more than once via \(debugInfo.file) at \(debugInfo.line)."
                )
            }
        }
    }
}


public func parallel<T1, T2, T3>(
    _ f1: @escaping (@escaping (T1) -> Void) -> Void,
    _ f2: @escaping (@escaping (T2) -> Void) -> Void,
    _ f3: @escaping (@escaping (T3) -> Void) -> Void,
    serialDispatcher: @escaping SerialDispatcher = asyncSerialDispatcher(),
    debugInfo: (file: String, line: UInt) = (file: #file, line: #line),
    _ callback: @escaping (T1, T2, T3) -> Void
) {
    parallel({ f1f2Callback in
        parallel(
            f1, f2,
            serialDispatcher: serialDispatcher,
            debugInfo: debugInfo,
            f1f2Callback
        )
    }, f3, serialDispatcher: serialDispatcher, debugInfo: debugInfo) { (x1x2, x3) in
        let (x1, x2) = x1x2
        callback(x1, x2, x3)
    }
}


public func parallel<T1, T2, T3, T4>(
    _ f1: @escaping (@escaping (T1) -> Void) -> Void,
    _ f2: @escaping (@escaping (T2) -> Void) -> Void,
    _ f3: @escaping (@escaping (T3) -> Void) -> Void,
    _ f4: @escaping (@escaping (T4) -> Void) -> Void,
    serialDispatcher: @escaping SerialDispatcher = asyncSerialDispatcher(),
    debugInfo: (file: String, line: UInt) = (file: #file, line: #line),
    _ callback: @escaping (T1, T2, T3, T4) -> Void
) {
    parallel({ f1f2f3Callback in
        parallel(
            f1, f2, f3,
            serialDispatcher: serialDispatcher,
            debugInfo: debugInfo,
            f1f2f3Callback
        )
    }, f4, serialDispatcher: serialDispatcher, debugInfo: debugInfo) { (x1x2x3, x4) in
        let (x1, x2, x3) = x1x2x3
        callback(x1, x2, x3, x4)
    }
}


public func parallel<T>(
    _ fs: [(@escaping (T) -> Void) -> Void],
    serialDispatcher: @escaping SerialDispatcher = asyncSerialDispatcher(),
    debugInfo: (file: String, line: UInt) = (file: #file, line: #line),
    _ callback: @escaping ([T]) -> Void
) {
    let first = { (intermediateCallback: @escaping ([T]) -> Void) in
        intermediateCallback([])
    }

    let last = fs.reduce(first) { (composedFs: @escaping (@escaping ([T]) -> Void) -> Void, f: @escaping (@escaping (T) -> Void) -> Void) in
        return { (intermediateCallback: @escaping ([T]) -> Void) in
            parallel(composedFs, f, serialDispatcher: serialDispatcher, debugInfo: debugInfo) { (xs, x) in
                var ys = xs
                ys.append(x)
                intermediateCallback(ys)
            }
        }
    }

    last(callback)
}
