import Foundation

import ReactiveSwift
import Result

class MVVMViewModel: NSObject {
    
    // MARK: Public Properties
    
    var configuration: ConfigurationInterface?
    
    let errorSignal: Signal<Error, NoError>
    let messageSignal: Signal<String, NoError>
    var loading = MutableProperty<Bool>(false)
    
    // MARK: Private Properties
    
    private var errorObserver: Signal<Error, NoError>.Observer
    private var messageObserver: Signal<String, NoError>.Observer
    
    // MARK: Initialization
    
    override init() {
        (errorSignal, errorObserver) = Signal<Error, NoError>.pipe()
        (messageSignal, messageObserver) = Signal<String, NoError>.pipe()
    }
    
    // MARK: Public Methods
    
    public func processError(_ error: Error) {
        errorObserver.send(value: error)
    }
    
    public func processMessage(_ message: String) {
        messageObserver.send(value: message)
    }
    
}
