import UIKit
import WebKit

private enum Constant {
    static let title = LocalizedString("Authorization")
}

class AuthorizationViewController: MVVMViewController, MVVMLifeCycleProtocol {
    
    // MARK: MVVMViewType
    
    var viewType: AuthorizationView! {
        return view as! AuthorizationView
    }
    
    // MARK: MVVMLifeCycle
    
    var viewModel: AuthorizationViewModel!
    var configuration: ConfigurationInterface!
    
    override var title: String? {
        get {
            return super.title ?? Constant.title
        }
        set {
            super.title = newValue
        }
    }
    
    // MARK: Life Cycle
    
    override func loadView() {
        view = AuthorizationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        
        viewType.webView.navigationDelegate = self
        
        // Step One: Direct your user to our authorization URL
        loadAuthorizationURL()
        
        bindViewModel(viewModel)
    }
    
    // MARK: MVVMLifeCycle
    
    func bindViewModel(_ viewModel: AuthorizationViewModel) {
        
        super.bindViewModel(viewModel)
    }
    
    // MARK: Private Methods
    
    func loadAuthorizationURL() {
        let urlString = "\(configuration.apiURL!)\(Endpoints.authorize.rawValue)/?client_id=\(configuration.instaClientID!)&redirect_uri=\(configuration.instaRedirectURL!)&response_type=code"
        
        if let url = URL(string: urlString) {
            viewType.webView.load(URLRequest(url: url))
        }
    }
        
    fileprivate func configureNavBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        
        let cancelItem = UIBarButtonItem.makeCancelItem(
            self,
            selector: #selector(cancelBarButtonItemTap(_:)))
        self.navigationItem.leftBarButtonItem = cancelItem
    }
    
    // MARK: Handlers
    
    @objc fileprivate func cancelBarButtonItemTap(_ item: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AuthorizationViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Step Two: Receive the redirect from Instagram
        
        if navigationAction.navigationType == .formSubmitted {
            if let url = navigationAction.request.url {
                if let code = viewModel.extractCode(url) {
                    // Step Three: Request the access_token
                    print("code: \(code)")
                    // self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        decisionHandler(.allow)
    }
    
}
