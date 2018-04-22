import Foundation

protocol MVVMLifeCycleProtocol {
    associatedtype ViewModel
    
    var viewModel: ViewModel! { get set }

    func bindViewModel(_ viewModel: ViewModel)
}
