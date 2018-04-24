import Foundation

import ReactiveCocoa
import ReactiveSwift
import Result

enum MediaCollectionViewModelError: LocalizedError {
    case couldNotLoadData
    
    var errorDescription: String? {
        switch self {
        case .couldNotLoadData:
            return LocalizedString("media.collection.could.not.load.data")
        }
    }
}

private enum Constant {
    static let numItems = 10
}

class MediaCollectionViewModel: MVVMViewModel {
    
    var repository: MediaCollectionRepository!
    
    fileprivate (set) var data = MutableProperty<MediaResponse?>(nil)
    
    override init() {
        
        super.init()
    }
    
    func loadMedia() {
        print(#function)
        
        repository.loadMedia(count: Constant.numItems) { [weak self] result in
            switch result {
            case let .success(value):
                if let value = value {
                    if self?.data.value == nil {
                        self?.data.value = value
                    } else {
                        self?.data.value?.pagination = value.pagination
                        self?.data.value?.data.append(contentsOf: value.data)
                    }
                } else if value == nil {
                    self?.processError(MediaCollectionViewModelError.couldNotLoadData)
                }
            case let .failure(error):
                self?.data.value = nil
                self?.processError(error)
            }
            self?.loading.value = false
        }
    }
    
}
