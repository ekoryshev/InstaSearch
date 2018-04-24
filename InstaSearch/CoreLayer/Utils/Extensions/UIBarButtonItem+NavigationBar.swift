import UIKit

/// This extension makes the buttons for using in Navigation bar
extension UIBarButtonItem {
    
    static func makeCancelItem(_ target: Any, selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: LocalizedString("Cancel"), style: .plain, target: target, action: selector)
    }
    
    static func makeLogInItem(_ target: Any, selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: LocalizedString("Log in"), style: .plain, target: target, action: selector)
    }
    
    static func makeLogOutItem(_ target: Any, selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: LocalizedString("Log out"), style: .plain, target: target, action: selector)
    }

    static func makeBackItem(_ target: Any, selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: LocalizedString("Back"), style: .plain, target: target, action: selector)
    }

}
