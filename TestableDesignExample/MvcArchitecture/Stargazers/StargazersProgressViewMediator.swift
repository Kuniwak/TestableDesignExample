import UIKit
import RxSwift


protocol StargazersProgressViewMediatorProtocol {
    weak var delegate: StargazersProgressViewMediatorDelegate? { get set }
}


protocol StargazersProgressViewMediatorDelegate: class {
}


class StargazersProgressViewMediator: StargazersProgressViewMediatorProtocol {
    private let progressView: UIProgressView
    private let disposeBag = RxSwift.DisposeBag()
    private let model: StargazerModelProtocol

    weak var delegate: StargazersProgressViewMediatorDelegate?


    init(
        observing model: StargazerModelProtocol,
        handling progressView: UIProgressView
    ) {
        self.model = model
        self.progressView = progressView

        self.model
            .didChange
            .subscribe(onNext: { [weak self] state in
                guard let this = self else { return }

                switch state {
                case .fetching:
                    this.presentLoadingState()

                case .fetched:
                    this.presentCompleteState()
                }
            })
            .disposed(by: self.disposeBag)
    }


    func presentLoadingState() {
        // NOTE: Fake progress X-D
        self.progressView.isHidden = false
        self.progressView.setProgress(0.8, animated: true)
    }


    func presentCompleteState() {
        self.progressView.setProgress(1.0, animated: true)
        self.progressView.isHidden = true
    }
}