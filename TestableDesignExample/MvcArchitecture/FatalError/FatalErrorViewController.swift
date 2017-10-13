import UIKit



class FatalErrorViewController: UIViewController {
    private var webPageOpener: UrlOpenerProtocol!


    static func create(contactUsVia webPageOpener: UrlOpenerProtocol) -> FatalErrorViewController {
        guard let viewController = R.storyboard.fatalErrorScreen.fatalErrorViewController() else {
            fatalError("FatalError screen is broken. We can do nothing anymore...")
        }

        viewController.webPageOpener = webPageOpener

        return viewController
    }



    static func create(debugInfo: Any) -> FatalErrorViewController {
        dump(debugInfo)
        return self.create(contactUsVia: UrlOpener())
    }



    @IBAction func contactButtonDidTap(_ sender: UIButton) {
        let url = URL(string:"https://github.com/Kuniwak/TestableDesignExample/issues/new")!
        self.webPageOpener.open(url: url)
    }
}
