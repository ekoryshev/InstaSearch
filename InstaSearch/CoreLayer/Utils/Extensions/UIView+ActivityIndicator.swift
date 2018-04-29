import Foundation
import UIKit

/// A UIView extension that adds the ability to show activity indicator at view.
extension UIView {
    
    /// The appearance default values
    private enum AppearanceDefaults {
        static var activityIndicatorColor: UIColor? = UIColor.black
        static var activityIndicatorBackgroundColor: UIColor? = UIColor.clear
    }
    
    /// The enum describes keys that uses as identifier for associated properties.
    private enum AssociatedKeys {
        static var activityIndicator = "UIView+ActivityIndicator.activityIndicator"
    }
    
    /// The enum describes animation duration.
    private enum AnimationDuration {
        /// Uses if animated flag is true
        static let withAnimation = 0.3
        /// Uses if animated flag is false
        static let withoutAnimation = 0.0
    }
    
    /// The activity indicator view
    var activityIndicator: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(
                self,
                &AssociatedKeys.activityIndicator
                ) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.activityIndicator,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    /// The activity indicator color
    @objc dynamic var activityIndicatorColor: UIColor? {
        get {
            return AppearanceDefaults.activityIndicatorColor
        }
        set {
            AppearanceDefaults.activityIndicatorColor = newValue
        }
    }
    
    /// The activity indicator style
    @objc dynamic var activityIndicatorStyle: UIActivityIndicatorViewStyle {
        get {
            return (self.activityIndicator?.activityIndicatorViewStyle)!
        }
        set {
            self.activityIndicator?.activityIndicatorViewStyle = newValue
        }
    }
    
    /// The activity indicator background color
    @objc dynamic var activityIndicatorBackgroundColor: UIColor? {
        get {
            return AppearanceDefaults.activityIndicatorBackgroundColor
        }
        set {
            AppearanceDefaults.activityIndicatorBackgroundColor = newValue
        }
    }
    
    /// Shows an activity indicator on own view.
    ///
    /// - Parameter animated: If true, the view was added to own view
    /// using an animation.
    func showActivityIndicator(_ animated: Bool = true) {
        // Creates an instance of activity indicator if it's nil
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView()
            activityIndicator?.frame = self.bounds
            activityIndicator?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            activityIndicator?.alpha = 0.0
            activityIndicator?.activityIndicatorViewStyle = activityIndicatorStyle
            activityIndicator?.color = AppearanceDefaults.activityIndicatorColor
            // swiftlint:disable:next line_length
            activityIndicator?.backgroundColor = activityIndicatorBackgroundColor ?? AppearanceDefaults.activityIndicatorBackgroundColor
        }
        
        guard let activityIndicator = activityIndicator else {
            return
        }
        
        if activityIndicator.superview == nil {
            let animated = animated ? AnimationDuration.withAnimation : AnimationDuration.withoutAnimation
            UIView.animate(withDuration: animated) {
                [weak self] in
                activityIndicator.alpha = 1.0
                self?.addSubview(activityIndicator)
            }
        }
        
        activityIndicator.startAnimating()
    }
    
    /// Hides an activity indicator on own view.
    ///
    /// - Parameter animated: If true, the view was removed from own view
    /// using an animation.
    func hideActivityIndicator(_ animated: Bool = true) {
        guard let activityIndicator = activityIndicator else {
            return
        }
        
        if activityIndicator.superview != nil {
            let animated = animated ? AnimationDuration.withAnimation : AnimationDuration.withoutAnimation
            UIView.animate(withDuration: animated) {
                activityIndicator.alpha = 0.0
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }
}
