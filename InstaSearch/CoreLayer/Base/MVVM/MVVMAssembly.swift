import Foundation

import Swinject

class MVVMAssembly: NSObject, Assembly {
    
    func assemble(container: Container) {
        container.register(SessionInterface.self) { _ in
            return Session.shared
        }

        container.register(ConfigurationInterface.self) { _ in
            return Configuration.shared
        }
        
        container.register(NetworkManagerInterface.self) { resolver in
            let manager = NetworkManager()
            manager.session = resolver.resolve(SessionInterface.self)
            manager.configuration = resolver.resolve(ConfigurationInterface.self)
            return manager
        }
    }
    
}
