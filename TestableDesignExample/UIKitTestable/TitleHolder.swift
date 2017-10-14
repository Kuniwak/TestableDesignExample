import UIKit



protocol TitleHolder {
    func setTitle(text: String)
}



class ViewControllerTitleHolder: TitleHolder {
    private weak var viewController: UIViewController?


    init(changeTitleOf viewController: UIViewController) {
        self.viewController = viewController
    }


    func setTitle(text: String) {
        self.viewController?.title = text
    }
}