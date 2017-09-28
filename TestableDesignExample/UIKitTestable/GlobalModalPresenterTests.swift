import UIKit
import XCTest
@testable import TestableDesignExample



class GlobalModalPresenterTests: XCTestCase {
    func testPresent() {
        let spyViewController = SpyViewController()
        let modalPresenter = GlobalModalPresenter()

        // NOTE: CPS is a simple way instead of Promisified tests in this case,
        // because this test target (UIViewController#present) is designed for CPS.
        let expectation = self.expectation(description: "Awaiting a call of viewDidAppear")

        modalPresenter.present(
            viewController: spyViewController,
            animated: false,
            completion: { _ in
                XCTAssertEqual(
                    spyViewController.callArgs,
                    [
                        .viewDidAppear(animated: true),
                    ]
                )
                expectation.fulfill()
            }
        )

        self.waitForExpectations(timeout: 1)
    }



    func testDismiss() {
        let spyViewController = SpyViewController()
        let modalPresenter = GlobalModalPresenter()

        // NOTE: CPS is a simple way instead of Promisified tests in this case,
        // because this test target (UIViewController#dismiss) is designed for CPS.
        let expectation = self.expectation(description: "Awaiting a call of viewDidDisappear")

        modalPresenter.present(
            viewController: spyViewController,
            animated: false,
            completion: { _ in
                modalPresenter.dissolver.dismiss(
                    animated: false,
                    completion: { _ in
                        XCTAssertEqual(
                            spyViewController.callArgs,
                            [
                                .viewDidAppear(animated: true),
                                .viewDidDisappear(animated: true),
                            ]
                        )
                        expectation.fulfill()
                    }
                )
            }
        )

        self.waitForExpectations(timeout: 1)
    }
}
