import Foundation

import Swinject

class AppAssembly: MVVMAssembly {
    
    override func assemble(container: Container) {
        super.assemble(container: container)
        
        container.register(MediaCollectionViewController.self) { resolver in
            let mediaCollectionResolver = Assembler([MediaCollectionAssembly()]).resolver
            return mediaCollectionResolver.resolve(MediaCollectionViewController.self)!
        }
        
        container.register(CustomNavigationController.self) { resolver in
            let navController = CustomNavigationController(
                rootViewController: resolver.resolve(MediaCollectionViewController.self)!)
            return navController
        }
    }
    
}
