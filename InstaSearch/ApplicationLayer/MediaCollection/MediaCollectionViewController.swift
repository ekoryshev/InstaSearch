import UIKit

import ReactiveSwift
import Swinject

private enum Constant {
    static let title = LocalizedString("InstaSearch")
}

class MediaCollectionViewController: MVVMViewController, MVVMLifeCycleProtocol {
    
    // MARK: MVVM
    
    var viewType: MediaCollectionView! {
        return view as! MediaCollectionView
    }
    
    var viewModel: MediaCollectionViewModel!
    var session: SessionInterface!
    
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
        view = MediaCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        
        bindViewModel(viewModel)
    }
    
    // MARK: MVVMLifeCycleProtocol

    func bindViewModel(_ viewModel: MediaCollectionViewModel) {
        super.bindViewModel(viewModel)
        
        if session.isAuthorized == true {
            viewModel.loadMedia()
        }
    }
    
    // MARK: Handlers
    
    @objc fileprivate func logInBarButtonItemTap(_ item: UIBarButtonItem) {
        let resolver = Assembler([AuthorizationAssembly()]).resolver
        let controller = resolver.resolve(CustomNavigationController.self)!
        
        if controller.viewControllers.count > 0 {
            if let authorizationViewController = (controller.viewControllers[0]
                as? AuthorizationViewController) {
                authorizationViewController.delegate = self
            }
        }
        
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc fileprivate func logOutBarButtonItemTap(_ item: UIBarButtonItem) {
        session.clear()
        configureNavBar()
    }
    
    // MARK: Private Methods
    
    fileprivate func configureNavBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        
        if session.isAuthorized == true {
            self.navigationItem.title = session.username
            
            let logOutItem = UIBarButtonItem.makeLogOutItem(
                self,
                selector: #selector(logOutBarButtonItemTap(_:)))
            self.navigationItem.rightBarButtonItem = logOutItem
        } else {
            self.navigationItem.title = Constant.title
            
            let logInItem = UIBarButtonItem.makeLogInItem(
                self,
                selector: #selector(logInBarButtonItemTap(_:)))
            self.navigationItem.rightBarButtonItem = logInItem
        }
    }
    
}

// MARK: AuthorizationViewControllerDelegate
extension MediaCollectionViewController: AuthorizationViewControllerDelegate {
    func authorizationModalDismissed() {
        if session.isAuthorized == true {
            viewModel.loadMedia()
            
            configureNavBar()
        }
    }
}
