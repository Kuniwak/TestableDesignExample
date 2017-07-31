iOS のためのテスト容易設計サンプル
==================================


アーキテクチャ
--------------

Smalltalk MVC を見本としています(Apple MVC とは違います).
Smalltalk MVC は、テスト容易なアーキテクチャの一つです。

![](https://raw.githubusercontent.com/Kuniwak/TestableDesignExample/master/Documentation/Images/ClassDiagram_Ja.png)



### サンプルコード

```swift
class FooViewController: UIViewController {
    private var model: FooModelContract!
    private var viewMediator: FooViewMediatorContract!
    private var controller: FooControllerContract!

    // この画面の初期状態を外から制御できるように FooModel を外部から渡す。
    static func create(model: FooModelContract) -> FooViewController? {
        guard let viewController = R.storyboard.fooScreen.FooViewController() else {
            return nil
        }

        viewController.model = model
        return viewController
    }


    @IBOutlet weak var barView: BarView!
    @IBOutlet weak var bazView: BizzView!

    // ここで Model と ViewMediator、Controller を接続する。
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
// FooModel は、FooModelState を状態としたステートマシンです。
// API 呼び出しの成功や失敗によって状態遷移が起きると、
// `didChange` という Observable を通して外部へ通知します。
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


// FooModel が取りうる状態の一覧。
enum FooModelState {
    case preparing
    case success
    case failure
}
```

```swift
// FooModel の状態変化に応じて表示を切り替えるクラス。
// Mediator とは、仲介者を意味していて、複数の UIView を
// 操作する責務をもっています。
class FooViewMediator: FooViewMediatorContract {
    typealias Views = (bar: BarView, baz: BuzzView)
    private let views: Views
    private let model: FooModelContract
    private let disposeBag = RxSwift.DisposeBag()

    // UIイベントを外部へ通知するための Delegate。
    weak var delegate: FooViewMediatorDelegate?


    init(observing model: FooModelContract, handling views: Views) {
        self.model = model
        self.views = views

        // モデルの状態遷移に応じて表示を切り替えます。
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

        // もし、子 View に変化があったら Delegate へ通知します。
        self.views.baz.addTarget(self, action: #selector(self.bazViewDidTap(sender:)))
    }


    @objc func bazViewDidTap(sender: Any) {
        self.delegate?.didSomething()
    }
}
```

```swift
// FooViewMediator からの UI イベントを、FooModel への入力へと変換します。
class FooController: FooControllerContract {
    fileprivate let model: FooModelContract

    init(willNotifyTo model: FooModelContract) {
        self.model = model
    }
}


extension FooController: FooViewMediatorDelegate {
    func didSomething() {
        self.model.doSomething()
    }
}
```



大域変数をどのようにコントロールするか
--------------------------------------
このプロジェクトでは、Stub と Spy という代替物を使って、大域変数を制御します（参考: [Test Doubles （英語）](http://xunitpatterns.com/Test%20Double.html)）。

![](https://raw.githubusercontent.com/Kuniwak/TestableDesignExample/master/Documentation/Images/TestDoubles_ja.png)


### サンプルコード
#### よくない設計（脆いテスト）

```swift
// よくない設計
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
// 製品コードの様子
let calc = UserDefaultsCalculator()
let value = calc.read10TimesValue()
calc.write10TimesValue(value)


// テストコードの様子A
let calc = UserDefaultsCalculator()
UserDefaults.standard.set(1, forKey: "foo")
XCTAssertEqual(calc.read10TimesValue(), 10)


// テストコードの様子B
let calc = UserDefaultsCalculator()
calc.write10TimesValue(1)
XCTAssertEqual(UserDefaults.standard.integer(forKey: "foo"), 10)
```


#### よい設計（堅牢なテスト）
```swift
// よい設計
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
// 製品コードの様子
let calc = UserDefaultsCalculator(
    reading: ReadableRepository(UserDefaults.standard),
    writing: WirtableRepository(UserDefaults.standard)
)
let value = calc.read10TimesValue()
calc.write10TimesValue(value)


// テストコードの様子A。UserDefaults には触れていないので堅牢。
let calc = UserDefaultsCalculator(
    reading: ReadableRepositoryStub(firstValue: 1),
    writing: WritableRepositorySpy()
)
XCTAssertEqual(calc.read10TimesValue(), 10)


// テストコードの様子B。UserDefaults には触れていないので堅牢。
let spy = WritableRepositorySpy()
let calc = UserDefaultsCalculator(
    reading: ReadableRepositoryStub(firstValue: 0),
    writing: spy
)
calc.write10TimesValue(1)
XCTAssertEqual(spy.callArgs.last!, 10)
```

```swift
// 代替物の定義

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
このプロジェクトでは、 [「もうE2Eテストはいらない（英語）」](https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html)というブログエントリに強く賛同します。

実際にこのプロジェクトでは、テストからのフィードバックを素早く受け取るために、型検査を他のテストより重視しています。
なぜなら、型検査は単体テストよりも効率的だからです。

![](https://raw.githubusercontent.com/Kuniwak/TestableDesignExample/master/Documentation/Images/TestEfficiency_ja.png)

例えば、`UITableViewCell` を `UITableView` に dequeue する前に register を呼んでいるという検査は型検査によって代替されています:

```swift
class MyCell: UITableViewCell {
    /**
     UITableView へ登録されたことを証明する登録証オブジェクト。
     */
    struct RegistrationToken {
        // Hide initializer to other objects.
        fileprivate init() {}
    }


    /**
     このセルクラスを UITableView へ登録し、登録証を発行します。
     */
    static func register(to tableView: UITableView) -> RegistrationToken {
        tableView.register(R.nib.myCell)
        return RegistrationToken()
    }


    /**
     UITableView から、このセルを dequeue します。
     このメソッド呼び出しには登録証が必須です
     （つまり、dequeue する前に resgister しないといけないということです）。
     */
    static func dequeue(
        by tableView: UITableView,
        for indexPath: IndexPath,
        andMustHave token: RegistrationToken
    ) -> MyCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: R.reuseIdentifier.myCell.identifier,
            for: indexPath
        ) as? StargazerCell else {
            // > dequeueReusableCell(withIdentifier:for:)
            // >
            // > UITableViewCell は reuse identifier によって関連付けされていれば、
            // > 必ず有効なセルを返します。
            // >
            // > https://developer.apple.com/reference/uikit/uitableview/1614878-dequeuereusablecell
            fatalError("必ず成功します")
        }

        // セルを設定します。

        return cell
    }
}
```

要するに、私たちは次のようなピラミッドに従う必要があると言い換えられます:

![理想的なテストは、ごくわずかなUIテストと、わずかな結合テストと、多くの単体テストと、極めて多くの型検査によって成り立つべきです。](https://raw.githubusercontent.com/Kuniwak/TestableDesignExample/master/Documentation/Images/TestingPyramid_ja.png)



参考文献
--------

1. XUnit Test Patterns: http://xunitpatterns.com/index.html
