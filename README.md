Testable design example for iOS Apps
====================================

This is a sample App to learn testable design.



Testing strategy
----------------
We stronlgy agree the blog entry; ["Just Say No to More End-to-End Tests"](https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html).

In this project, we use type-checking instead of other tests (unit tests and integration tests and UI tests) to get feedbacks from tests rapidly. Because type-checking is higher effictiveness than other tests.

![](https://raw.githubusercontent.com/Kuniwak/TestableDesignExample/master/Documentation/Images/TestEfficiency.png)

For example, we can check registering UITableViewCell to UITableVIew before dequeueing by using type-checking:

```swift
class MyCell: UITableViewCell {
    /**
     A class for registration token that will create after registering the cell to the specified UITableView.
     */
    struct RegistrationToken {
        // Hide initializer to other objects.
        fileprivate init() {}
    }


    /**
     Registers the cell class to the specified UITableView and returns a registration token.
     */
    static func register(to tableView: UITableView) -> RegistrationToken {
        tableView.register(R.nib.stargazerCell)
        return RegistrationToken()
    }


    /**
     Dequeues the cell by the specified UITableView.
     You must have a registration token (it means you must register the cell class before dequeueing).
     */
    static func dequeue(
        by tableView: UITableView,
        for indexPath: IndexPath,
        andMustHave token: RegistrationToken
    ) -> MyCell {
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

        // Configuring the cell.

        return cell
    }
}
```

Taken together, we should follow the Test Pyramid:

![Ideal test volume is extlemly few UI tests and few integration tests and much unit tests and much type checkings.](https://raw.githubusercontent.com/Kuniwak/TestableDesignExample/master/Documentation/Images/TestPyramid.png)



Architecture
------------

Smalltalk flavored MVC (not Apple MVC). Smalltalk flavored MVC is a architecture that can test easily.

![](https://raw.githubusercontent.com/Kuniwak/TestableDesignExample/master/Documentation/Images/ClassDiagram_En.png)
