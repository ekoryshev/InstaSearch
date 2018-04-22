import Foundation
import UIKit

import ReactiveCocoa
import ReactiveSwift

class MVVMViewController: UIViewController {
    
    func bindViewModel(_ viewModel: MVVMViewModel) {
        viewModel.loading.signal
            .observe(on: UIScheduler())
            .take(duringLifetimeOf: self)
            .observeValues { [weak self] loaded in
                if loaded == true {
                    self?.view.showActivityIndicator()
                } else {
                    self?.view.hideActivityIndicator()
                }
        }
        
        viewModel.errorSignal
            .observe(on: UIScheduler())
            .take(duringLifetimeOf: self)
            .map { [weak self] (error: Error) -> String in
                self?.mapError(error) ?? ""
            }
            .observeValues { [weak self] in
                if !$0.isEmpty {
                    // self?.showErrorMessage($0) // FIXME!
                }
        }
        
        viewModel.messageSignal
            .observe(on: UIScheduler())
            .take(duringLifetimeOf: self)
            .observeValues { [weak self] message in
                // self?.showMessage(message) // FIXME!
        }
    }
    
    func mapError(_ error: Error) -> String {
        return error.localizedDescription
    }
    
    deinit {
        debugLog("\(NSStringFromClass(self.classForCoder)) was deinited")
    }
}
