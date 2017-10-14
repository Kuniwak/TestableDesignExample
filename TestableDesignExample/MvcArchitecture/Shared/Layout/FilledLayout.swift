import UIKit



enum FilledLayout {
    static func fill(subview: UIView, into superview: UIView) {
        let constraints: [NSLayoutConstraint] = [
            superview.topAnchor.constraint(equalTo: subview.topAnchor),
            superview.bottomAnchor.constraint(equalTo: subview.bottomAnchor),
            superview.leftAnchor.constraint(equalTo: subview.leftAnchor),
            superview.rightAnchor.constraint(equalTo: subview.rightAnchor),
        ]

        constraints.forEach { constraint in
            constraint.isActive = true
        }
    }
}
