import UIKit
import RxSwift


protocol StargazersProgressViewBindingProtocol {}


class StargazersProgressViewBinding: StargazersProgressViewBindingProtocol {
    private let progressView: UIProgressView
    private let disposeBag = RxSwift.DisposeBag()
    private let model: StargazersModelProtocol


    init(
        observing model: StargazersModelProtocol,
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