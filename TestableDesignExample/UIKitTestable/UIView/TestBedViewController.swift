import UIKit
import XCTest



func waitUntilVisible(
    on test: XCTestCase,
    at line: UInt = #line,
    testing view: UIView,
    _ viewDidLoad: @escaping (@escaping () -> Void) -> Void
) {
    let keyWindow: UIWindow = UIApplication.shared.keyWindow ?? {
        let window = UIWindow()
        window.makeKeyAndVisible()
        return window
    }()

    let expectation = test.expectation(description: "Awaiting callback that was given to viewDidLoad")

    keyWindow.rootViewController = TestBedViewController(
        testing: view,
        didLoad: {
            viewDidLoad({ expectation.fulfill() })
        }
    )

    test.waitForExpectations(timeout: 1)
}


func waitUntilVisible(
    on test: XCTestCase,
    at line: UInt = #line,
    testing view: UIView,
    _ viewDidLoad: @escaping () -> Void
) {
    waitUntilVisible(on: test, at: line, testing: view) { fulfill in
        fulfill()
    }
}



class TestBedViewController: UIViewController {
    private let viewDidLoadCallback: () -> Void
    private let targetView: UIView


    init(
        testing targetView: UIView,
        didLoad viewDidLoadCallback: @escaping () -> Void
    ) {
        self.viewDidLoadCallback = viewDidLoadCallback
        self.targetView = targetView

        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder aDecoder: NSCoder) {
        return nil
    }


    override func loadView() {
        let rootView = UIView()
        rootView.addSubview(self.targetView)

        [
            rootView.centerXAnchor.constraint(equalTo: self.targetView.centerXAnchor),
            rootView.centerYAnchor.constraint(equalTo: self.targetView.centerYAnchor),
        ].forEach { $0.isActive = true }

        self.view = rootView
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewDidLoadCallback()
    }
}
