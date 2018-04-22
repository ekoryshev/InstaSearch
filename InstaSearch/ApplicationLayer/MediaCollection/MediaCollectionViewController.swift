import Foundation
import UIKit

class MediaCollectionViewController: MVVMViewController, MVVMLifeCycleProtocol {
    
    // MARK: MVVM
    
    var viewType: MediaCollectionView! {
        return view as! MediaCollectionView
    }
    
    var viewModel: MediaCollectionViewModel!
    
    // MARK: Life Cycle
    
    override func loadView() {
        view = MediaCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel(viewModel)
    }
    
    // MARK: MVVMLifeCycleProtocol

    func bindViewModel(_ viewModel: MediaCollectionViewModel) {
        super.bindViewModel(viewModel)
    }
    
}
