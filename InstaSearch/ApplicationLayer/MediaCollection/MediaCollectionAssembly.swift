import Foundation

import Swinject

class MediaCollectionAssembly: MVVMAssembly {
    
    override func assemble(container: Container) {
        super.assemble(container: container)

        container.register(MediaCollectionViewModel.self) { resolver in
            return MediaCollectionViewModel()
        }
        
        container.register(MediaCollectionViewController.self) { resolver in
            let controller = MediaCollectionViewController()
            controller.viewModel = resolver.resolve(MediaCollectionViewModel.self)
            return controller
        }
    }
    
}
