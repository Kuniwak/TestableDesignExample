import UIKit



extension UIScrollView {
    static func create(
        sizeOf size: (scrollView: CGSize, contentView: CGSize) = UIScrollView.defaultSize,
        scrolledAt contentOffset: CGPoint = .zero
    ) -> (scrollView: UIScrollView, contentView: UIView) {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false

        [
            scrollView.heightAnchor.constraint(equalToConstant: size.scrollView.height),
            scrollView.widthAnchor.constraint(equalToConstant: size.scrollView.width),
            contentView.heightAnchor.constraint(equalToConstant: size.contentView.height),
            contentView.widthAnchor.constraint(equalToConstant: size.contentView.width),
        ].forEach { $0.isActive = true }

        scrollView.addSubview(contentView)

        scrollView.setContentOffset(contentOffset, animated: false)

        return (
            scrollView: scrollView,
            contentView: contentView
        )
    }


    private static var defaultSize: (scrollView: CGSize, contentView: CGSize) = (
        scrollView: CGSize(width: 100, height: 100),
        contentView:  CGSize(width: 100, height: 200)
    )
}