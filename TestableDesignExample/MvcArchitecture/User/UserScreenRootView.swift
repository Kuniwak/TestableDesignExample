import UIKit



class UserScreenRootView: UIView {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imageView: UIImageView!


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadFromXib()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadFromXib()
    }


    private func loadFromXib() {
        guard let view = R.nib.userScreenRootView.firstView(owner: self) else {
            return
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        FilledLayout.fill(subview: view, into: self)
        self.layoutIfNeeded()
    }
}
