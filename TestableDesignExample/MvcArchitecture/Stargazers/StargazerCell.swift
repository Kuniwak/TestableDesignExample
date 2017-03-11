import UIKit



class StargazerCell: UITableViewCell {
    @IBOutlet weak var starIconLabel: UILabel!
    @IBOutlet weak var repositoryFullNameLabel: UILabel!


    static func dequeue(
        cellOf stargazer: GitHubUser,
        by tableView: UITableView,
        for indexPath: IndexPath,
        andMustHave token: RegistrationToken
    ) -> StargazerCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: R.reuseIdentifier.stargazerCell.identifier,
            for: indexPath
        ) as? StargazerCell else {
            // > dequeueReusableCell(withIdentifier:for:)
            // >
            // > A UITableViewCell object with the associated reuse identifier.
            // > This method always returns a valid cell.
            // >
            // > https://developer.apple.com/reference/uikit/uitableview/1614878-dequeuereusablecell
            fatalError("This case must be success")
        }

        cell.starIconLabel.text = "\u{f02a}"
        cell.repositoryFullNameLabel.text = stargazer.name.text

        return cell
    }


    static func register(to tableView: UITableView) -> RegistrationToken {
        tableView.register(R.nib.stargazerCell)
        return RegistrationToken()
    }



    struct RegistrationToken {
        fileprivate init() {}
    }
}