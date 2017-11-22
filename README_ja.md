iOS のためのテスト容易設計サンプル
==================================

[![Build Status](https://www.bitrise.io/app/97b1fa446d801c01/status.svg?token=_uFGlK9iYeSQdtXnnPufYw&branch=master)](https://www.bitrise.io/app/97b1fa446d801c01)

テスト容易な設計で実装された、特定の GitHub のリポジトリに Star したユーザーを閲覧するアプリです。

![](https://raw.githubusercontent.com/Kuniwak/TestableDesignExample/master/Documentation/Images/Screenshots.png)

このアプリの実装を読むことで、以下のプラクティスが得られるでしょう:

- テストを容易にするための疎結合実装例（MVC アーキテクチャを採用しています）
- 大域変数を差し替え可能にする実装例
- 型検査を重視するテスト戦略



アーキテクチャ
--------------

このアプリでは、Smalltalk MVC を見本としています(Apple MVC とは違います).
この Smalltalk MVC は、テスト容易なアーキテクチャの一つです。
他にも MVVM や MVP や Flux、VIPER などのアーキテクチャが有名ですが、これらに劣らず疎結合でテストしやすい実装が可能です。

![](https://raw.githubusercontent.com/Kuniwak/TestableDesignExample/master/Documentation/Images/ClassDiagram_Ja.png)

どのアーキテクチャを選ぶにしても、それぞれのアーキテクチャ上で気をつけなければならないことは共通しています。
したがって、最終的にあなたがどのアーキテクチャを選ぼうとも、ここで得た知見は無駄にならないでしょう。



### サンプルコード

このプロジェクトでは、1つの `UIViewController` に対し、1つの Xib ファイルが対応するようにしてあります。
また、すべての `UIViewController` の子クラスの初期化関数は Model を引数にとります。

また、`UIViewController#loadView()` のタイミングで、ViewBinding と Controller が作成され、与えられた Model と接続されます。

具体的なコードは以下の通りです:

```swift
class FooViewController: UIViewController {
    private var model: FooModelContract
    private var viewBinding: FooViewBindingContract?
    private var controller: FooControllerContract?

    init(model: FooModelContract) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        // NOTE: このプロジェクトでは特に ViewController の復元は使わない。
        return nil
    }

    // Model と ViewBinding, Controller を結合する。
    override func loadView() {
        let rootView = FooRootView()
        self.view = rootView

        let controller = FooController(
            observing: rootView.barView,
            willNotifyTo: self.model
        )
        self.controller = controller

        self.viewBinding = FooViewBinding(
            observing: self.model,
            handling: (
                bar: rootView.barView,
                baz: rootView.bazView
            )
        )
        self.viewBinding.delegate = controller
    }
}
```

```swift
// FooModel は、FooModelState を状態としたステートマシンです。
// API 呼び出しの成功や失敗によって状態遷移が起きると、
// `didChange` という Observable を通して外部へ通知します。
class FooModel: FooModelContract {
    private let repository: FooRepositoryContract
    private let stateVariable: RxSwift.Variable<FooModelState>

    /// FooModel の内部状態に変化があったら通知される Observable。
    var didChange: RxSwift.Observable<FooModelState> {
        return self.stateVariable.asObservable()
    }

    /// FooModel の現在の状態。
    var currentState: FooModelState {
        get { return self.stateVariable.value }
        set { self.stateVariable.value = newValue }
    }

    init(
        startingWith initialState: FooModelState,
        fetchingVia repository: FooRepositoryContract
    ) {
        self.stateVariable = RxSwift.Variable<FooModelState>(initialState)
        self.repository = repository
    }

    func doSomething() {
        switch self.currentState {
        case .preparing:
            // NOTE: 重複実行を防止する。
            return

        case .success, .failure:
            self.currentState = .preparing

            self.repository
                .doSomething()
                .then { entity in 
                    self.currentState = .success(entity)
                }
                .catch { error in
                    self.currentState = .failure(
                        because: .unspecified(debugInfo: "\(error)")
                    )
                }
        }
    }
}


// FooModel が取りうる状態の一覧。
enum FooModelState {
    case preparing
    case success(Entity)
    case failure(because: Reason)

    enum Reason {
        case unspecified(debugInfo: String)
    }
}
```

```swift
// FooModel の状態変化に応じて表示を切り替えるクラス。
// Binding とは、仲介者を意味していて、複数の UIView を
// 操作する責務をもっています。
class FooViewBinding: FooViewBindingContract {
    typealias Views = (bar: BarView, baz: BuzzView)
    private let views: Views
    private let model: FooModelContract
    private let disposeBag = RxSwift.DisposeBag()

    init(observing model: FooModelContract, handling views: Views) {
        self.model = model
        self.views = views

        // NOTE: モデルの状態遷移に応じて表示を切り替えます。
        self.model
            .didChange
            .subscribe(onNext: { [weak self] state in
                guard let this = self else { return }
                switch state {
                case .preparing:
                    this.views.bar.text = "preparing"
                case let .success(entity):
                    this.views.bar.text = "success \(entity)"
                case let .failure(because: reason):
                    this.views.bar.text = "failure \(reason)"
                }
            })
            .disposed(by: self.disposeBag)
    }
}
```

```swift
// BarView からの UI イベントを、FooModel への入力へと変換します。
class FooController: FooControllerContract {
    private let model: FooModelContract
    private let view: BarView
    private let disposeBag = RxSwift.DisposeBag()

    init(
        observing view: BarView,
        willNotifyTo model: FooModelContract
    ) {
        self.model = model

        // NOTE: BarView の UI イベントを監視し、FooModel へと通知します。
        view.rx.tap
            .asDriver
            .drive(onNext: { [weak self] _ in 
                guard let this = self else { return }

                this.model.doSomething()
            })
            .disposed(by: self.disposeBag)
    }
}
```


UIViewController 間の接続方法
-----------------------------

このプロジェクトでは、2つの `UIViewController` 間の接続に `Navigator` というクラスが利用されています:

```swift
class FooViewController: UIViewController {
    private let navigator: NavigatorContract
    private let sharedModel: FooBarModelContract

    init(
        representing sharedModel: FooBarModelContract,
        navigatingBy navigator: NavigatorContract
    ) {
        self.sharedModel = sharedModel
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    @IBAction func buttonDidTap(sender: Any) {
        let nextViewController = BarViewController(
            representing: sharedModel
        )
        self.navigator.navigate(to: nextViewController)
    }
}
```

画面遷移に `UIStoryboardSegue` を使うこともできますが、Navigator を使うと2つの利点があります:

- 遷移時の共通処理（解析用のログ送信など）をシンプルに実装しやすい
- 必要なオブジェクトの宣言を一箇所に集中させられる



### `Navigator` クラスの実装

```swift
/**
 `UINavigationController#pushViewController(_:UIViewController, animated:Bool)` のラッパークラス。
 */
protocol NavigatorContract {
    /**
     UIViewController を保持している UINavigationController へ push する。
     */
    func navigate(to viewController: UIViewController, animated: Bool)
}



class Navigator: NavigatorContract {
    private let navigationController: UINavigationController


    init (for navigationController: UINavigationController) {
        self.navigationController = navigationController
    }


    func navigate(to viewController: UIViewController, animated: Bool) {
        self.navigationController.pushViewController(
            viewController,
            animated: animated
        )
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
        reading readableRepository: ReadableRepositoryContract,
        writing writableRepository: WritableRepositoryContract
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



テスト戦略
----------
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
        ) as? MyCell else {
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
