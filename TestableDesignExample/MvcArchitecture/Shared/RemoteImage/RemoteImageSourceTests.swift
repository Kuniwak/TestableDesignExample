import XCTest
import UIKit
import RxSwift
import RxBlocking
@testable import TestableDesignExample



class RemoteImageSourceTests: XCTestCase {
    func testFetch() {
        let imageView = UIImageView()
        let sampleImageUrl = URL(string: "https://via.placeholder.com/100")!

        let source = RemoteImageSource(willUpdate: imageView)
        source.fetch(from: sampleImageUrl)

        self.waitWhilePending(source)

        switch source.currentState {
        case let .success(image: image):
            XCTAssertNotNil(imageView.image)
            XCTAssertEqual(imageView.image, image)
        default:
            XCTFail("Unexpected state: \(source.currentState)")
        }
    }


    func testSet() {
        let imageView = UIImageView()
        let sampleImage = R.image.sample()!

        let source = RemoteImageSource(willUpdate: imageView)
        source.set(image: sampleImage)

        self.waitWhilePending(source)

        switch source.currentState {
        case let .success(image: image):
            XCTAssertNotNil(imageView.image)
            XCTAssertEqual(imageView.image, image)
        default:
            XCTFail("Unexpected state: \(source.currentState)")
        }
    }


    func testError() {
        let imageView = UIImageView()
        let errorImageUrl = URL(string: "https://error.example.com/nothing.png")!

        let source = RemoteImageSource(willUpdate: imageView)
        source.fetch(from: errorImageUrl)

        self.waitWhilePending(source)

        switch source.currentState {
        case let .failure(reason: error):
            XCTAssertNil(imageView.image)
            XCTAssert(String(describing: error).contains("NSURLErrorDomain"), String(describing: error))
        default:
            XCTFail("Unexpected state: \(source.currentState)")
        }
    }


    private func waitWhilePending(_ source: RemoteImageSource) {
        _ = try! source.didChange
            .asObservable()
            .filter { state in
                switch state {
                case .pending:
                    return false
                case .success, .failure:
                    return true
                }
            }
            .take(1)
            .toBlocking()
            .last()
    }
}
