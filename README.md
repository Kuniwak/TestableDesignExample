Testable design example for iOS Apps
====================================

This is a sample App to learn testable design.



Architecture
------------

Smalltalk flavored MVC (not Apple MVC). Smalltalk flavored MVC is a architecture that can test easily.

![](https://raw.githubusercontent.com/Kuniwak/TestableDesignExample/master/Documentation/Images/ClassDiagram_En.png)

### Sample Code

```swift
class FooViewController: UIViewController {
    private var model: FooModelContract!
    private var viewMediator: FooViewMediatorContract!
    private var controller: FooControllerContract!

    // We should give FooModel to be able to change initial state of the screen.
    static func create(model: FooModelContract) -> FooViewController? {
        guard let viewController = R.storyboard.fooScreen.FooViewController() else {
            return nil
        }

        viewController.model = model
        return viewController
    }


    @IBOutlet weak var barView: BarView!
    @IBOutlet weak var bazView: BizzView!

    // Connect Model and ViewMediator, Controller.
    override func viewDidLoad() {
        super.viewDidLoad()

        let controller = FooController(
            willNotifyTo: self.model,
        )
        self.controller = controller

        self.viewMediator = FooViewMediator(
            observing: self.model,
            handling: (
                bar: self.barView,
                baz: self.bazView
            )
        )
        self.viewMediator.delegate = controller
    }
}
```

```swift
// FooModel is a state-machine that can transit to FooModelState.
// Notify change events to others via an observable `didChange` when
// API was successfully done or failed.
class FooModel: FooModelContract {
    private let repository: FooRepositoryContract
    private let stateVariable = RxSwift.Variable<FooModelState>(.preparing)

    var didChange: RxSwift.Observable<FooModelState> {
        return self.stateVariable.asObservable()
    }

    init(fetchingVia repository: FooRepositoryContract) {
        self.repository = repository
    }

    func doSomething() {
        // Notify a state change event to others.
        self.repository
            .doSomething()
            .then { self.stateVariable.value = .success }
            .catch { self.stateVariable.value = .failure }
    }
}


// States that FooModel can transit to.
enum FooModelState {
    case preparing
    case success
    case failure
}
```

```swift
class FooViewMediator: FooViewMediatorContract {
    typealias Views = (bar: BarView, baz: BuzzView)
    private let views: Views
    private let model: FooModelContract
    private let disposeBag = RxSwift.DisposeBag()

    // A delegate for notifying UI events to others.
    weak var delegate: FooViewMediatorDelegate?


    init(observing model: FooModelContract, handling views: Views) {
        self.model = model
        self.views = views

        // Change visual by observing model's state transitions.
        self.model
            .didChange
            .subscribe(onNext: { [weak var] state in
                switch {
                case .preparing:
                    self?.views.bar.text = "preparing"
                case .success:
                    self?.views.bar.text = "success"
                case .failure:
                    self?.views.bar.text = "failure"
                }
            })
            .addDisposableTo(self.disposeBag)

        // Notify to its delegate when child view was changed.
        self.views.baz.addTarget(self, action: #selector(self.bazViewDidTap(sender:)))
    }


    @objc func bazViewDidTap(sender: Any) {
        self.delegate?.didSomething()
    }
}
```

```swift
class FooController: FooControllerContract {
    fileprivate let model: FooModelContract

    init(willNotifyTo model: FooModelContract) {
        self.model = model
    }
}


// Notify user interactions to the model via the viewMediator.
extension FooController: FooViewMediatorDelegate {
    func didSomething() {
        self.model.doSomething()
    }
}
```



How to control global vars
--------------------------
In this project, we control global variables by using [test doubles](http://xunitpatterns.com/Test%20Double.html); Stub and Spy.

![](https://raw.githubusercontent.com/Kuniwak/TestableDesignExample/master/Documentation/Images/TestDoubles_en.png)


### Sample code
#### Bad Design (fragile tests)

```swift
// BAD DESIGN
class UserDefaultsCalculator {
    func read10TimesValue() {
        return UserDefaults.standard.integer(forKey: "foo") * 10
    }


    func write10TimesValue(_ value: Int) {
        UserDefaults.standard.set(value * 10, forKey: "foo")
    }
}
```

```swift
// In production code:
let calc = UserDefaultsCalculator()
let value = calc.read10TimesValue()
calc.write10TimesValue(value)


// In the unit-test A, it is fragile :-(
let calc = UserDefaultsCalculator()
UserDefaults.standard.set(1, forKey: "foo")
XCTAssertEqual(calc.read10TimesValue(), 10)


// In the unit-test B, it is also fragile :-(
let calc = UserDefaultsCalculator()
calc.write10TimesValue(1)
XCTAssertEqual(UserDefaults.standard.integer(forKey: "foo"), 10)
```


#### Good Design (robust tests)
```swift
// GOOD DESIGN
class UserDefaultsCalculator {
    private let readableRepository: ReadableRepositoryContract
    private let writableRepository: WritableRepositoryContract


    init(
        reading readableRepository, ReadableRepositoryContract,
        writing writableRepository, WritableRepositoryContract
    ) {
        self.readableRepository = readableRepository
        self.writableRepository = writableRepository
    }


    func read10TimesValue() {
        return self.readableRepository.read() * 10
    }


    func write10TimesValue(value: Int) {
        self.writableRepository.write(value * 10)
    }
}


protocol ReadableRepositoryContract {
    func read() -> Int
}


class ReadableRepository: ReadableRepositoryContract {
    private let userDefaults: UserDefaults


    init(reading userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }


    func read() -> Int {
        return self.userDefaults.integer(forKey: "foo")
    }
}


protocol WritableRepositoryContract {
    func write(_ value: Int)
}


class WritableRepository: WritableRepositoryContract {
    private let userDefaults: UserDefaults


    init(reading userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }


    func write(_ value: Int) {
        self.userDefaults.set(value, forKey: "foo")
    }
}
```


```swift
// In production code:
let calc = UserDefaultsCalculator(
    reading: ReadableRepository(UserDefaults.standard),
    writing: WirtableRepository(UserDefaults.standard)
)
let value = calc.read10TimesValue()
calc.write10TimesValue(value)


// In the unit-test A, it is robust, because
// we don't touch actual UserDefaults :-D
let calc = UserDefaultsCalculator(
    reading: ReadableRepositoryStub(firstValue: 1),
    writing: WritableRepositorySpy()
)
XCTAssertEqual(calc.read10TimesValue(), 10)


// In the unit-test B, it is also robust :-D
let spy = WritableRepositorySpy()
let calc = UserDefaultsCalculator(
    reading: ReadableRepositoryStub(firstValue: 0),
    writing: spy
)
calc.write10TimesValue(1)
XCTAssertEqual(spy.callArgs.last!, 10)
```

```swift
// TestDoubles definitions

class ReadableRepositoryStub: ReadableRepositoryContract {
    var nextValue: Int

    init(firstValue: Int) {
        self.nextValue = firstValue
    }

    func read() {
        return self.nextValue
    }
}


class WritableRepositorySpy: WritableRepositoryContract {
    private(set) var callArgs = [Int]()

    func write(_ value: Int) {
        self.callArgs.append(value)
    }
}
```



Testing strategy
----------------
We stronlgy agree the blog entry; ["Just Say No to More End-to-End Tests"](https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html).

In this project, we use type-checking instead of other tests (unit tests and integration tests and UI tests) to get feedbacks from tests rapidly. Because type-checking is higher effictiveness than other tests.

![](https://raw.githubusercontent.com/Kuniwak/TestableDesignExample/master/Documentation/Images/TestEfficiency.png)

For example, we can check registering `UITableViewCell` to `UITableVIew` before dequeueing by using type-checking:

```swift
class MyCell: UITableViewCell {
    /**
     A class for registration token that will create after registering the cell to the specified UITableView.
     */
    struct RegistrationToken {
        // Hide initializer to other objects.
        fileprivate init() {}
    }


    /**
     Registers the cell class to the specified UITableView and returns a registration token.
     */
    static func register(to tableView: UITableView) -> RegistrationToken {
        tableView.register(R.nib.stargazerCell)
        return RegistrationToken()
    }


    /**
     Dequeues the cell by the specified UITableView.
     You must have a registration token (it means you must register the cell class before dequeueing).
     */
    static func dequeue(
        by tableView: UITableView,
        for indexPath: IndexPath,
        andMustHave token: RegistrationToken
    ) -> MyCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: R.reuseIdentifier.stargazerCell.identifier,
            for: indexPath
        ) as? StargazerCell else {
            // > dequeueReusableCell(withIdentifier:for:)
            // >
            // > A UITableViewCell object with the associated reuse identifier.
            // > This method always returns a valid cell.
            // >
            // > https://developer.apple.com/reference/uikit/uitableview/1614878-dequeuereusablecell
            fatalError("This case must be success")
        }

        // Configuring the cell.

        return cell
    }
}
```

Taken together, we should follow the Test Pyramid:

![Ideal test volume is extlemly few UI tests and few integration tests and much unit tests and much type checkings.](https://raw.githubusercontent.com/Kuniwak/TestableDesignExample/master/Documentation/Images/TestPyramid.png)



References
----------

1. XUnit Test Patterns: http://xunitpatterns.com/index.html
