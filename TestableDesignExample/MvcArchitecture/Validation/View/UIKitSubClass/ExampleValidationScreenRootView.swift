import UIKit



class ExampleValidationScreenRootView: UIView {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameHintLabel: UILabel!
    @IBOutlet weak var passwordHintLabel: UILabel!


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadFromXib()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadFromXib()
    }


    private func loadFromXib() {
        guard let view = R.nib.exampleValidationScreenRootView.firstView(owner: self) else {
            return
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        FilledLayout.fill(subview: view, into: self)
        self.layoutIfNeeded()
    }
}
