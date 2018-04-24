import UIKit
import WebKit

import SnapKit

class AuthorizationView: UIView {
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    fileprivate (set) var webView: WKWebView!
 
    convenience init() {
        self.init(frame: .zero)
        
        webView = WKWebView()
        addSubview(webView)
    }
    
    override func updateConstraints() {
        webView.snp.updateConstraints { maker in
            maker.leading.equalTo(self)
            maker.trailing.equalTo(self)
            maker.top.equalTo(self)
            maker.bottom.equalTo(self)
        }
        
        super.updateConstraints()
    }
    
}
