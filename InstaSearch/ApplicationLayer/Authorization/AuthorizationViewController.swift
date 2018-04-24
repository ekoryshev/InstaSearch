import UIKit
import WebKit

import ReactiveSwift

private enum Constant {
    static let title = LocalizedString("Authorization")
}

protocol AuthorizationViewControllerDelegate: class {
    func authorizationModalDismissed()
}

class AuthorizationViewController: MVVMViewController, MVVMLifeCycleProtocol {
    
    // MARK: MVVMViewType
    
    var viewType: AuthorizationView! {
        return view as! AuthorizationView
    }
    
    // MARK: MVVMLifeCycle
    
    var viewModel: AuthorizationViewModel!
    weak var delegate: AuthorizationViewControllerDelegate?
    
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
        authorize()
        
        bindViewModel(viewModel)
    }
    
    // MARK: MVVMLifeCycle
    
    func bindViewModel(_ viewModel: AuthorizationViewModel) {
        super.bindViewModel(viewModel)
        
        configureCloseModuleSignal(viewModel)
    }
    
    // MARK: Private Methods
    
    func authorize() {
        if let url = viewModel.getAuthorizationURL() {
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
    
    fileprivate func configureCloseModuleSignal(_ viewModel: AuthorizationViewModel) {
        viewModel.closeModuleSignal
            .observe(on: UIScheduler())
            .take(duringLifetimeOf: self)
            .observeValues { [weak self] in
                withExtendedLifetime(self) {
                    self?.delegate?.authorizationModalDismissed()
                    self?.dismiss(animated: true)
                }
        }
    }
    
    // MARK: Handlers
    
    @objc fileprivate func cancelBarButtonItemTap(_ item: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AuthorizationViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Step Two: Receive the redirect from Instagram

        if navigationAction.navigationType != .formSubmitted
            && navigationAction.navigationType.rawValue != -1 {
            decisionHandler(.allow)
            return
        }
        
        if let url = navigationAction.request.url {
            if let code = viewModel.extractCode(url) {
                // Step Three: Request the access_token
                print("code: \(code)")
                decisionHandler(.cancel)
                viewModel.authorize(code: code)
            } else if let error = viewModel.extractError(url) {
                print("error: \(error)")
                decisionHandler(.cancel)
                self.dismiss(animated: true, completion: nil)
            } else {
                decisionHandler(.allow)
            }
        }
    }
}
