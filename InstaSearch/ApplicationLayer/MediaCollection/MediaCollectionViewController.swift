import UIKit

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
    }
    
    // MARK: Handlers
    
    @objc fileprivate func logInBarButtonItemTap(_ item: UIBarButtonItem) {
        let resolver = Assembler([AuthorizationAssembly()]).resolver
        let controller = resolver.resolve(CustomNavigationController.self)!
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: Private Methods
    
    fileprivate func configureNavBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        
        let logInItem = UIBarButtonItem.makeLogInItem(
            self,
            selector: #selector(logInBarButtonItemTap(_:)))
        self.navigationItem.rightBarButtonItem = logInItem
    }
}
