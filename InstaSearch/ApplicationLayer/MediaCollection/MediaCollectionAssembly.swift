import Foundation

import Swinject

class MediaCollectionAssembly: MVVMAssembly {
    
    override func assemble(container: Container) {
        super.assemble(container: container)

        container.register(MediaCollectionViewModel.self) { resolver in
            let viewModel = MediaCollectionViewModel()
            viewModel.repository = resolver.resolve(MediaCollectionRepository.self)
            return viewModel
        }
        
        container.register(MediaCollectionRepository.self) { resolver in
            let repository = MediaCollectionRepository()
            repository.session = resolver.resolve(SessionInterface.self)
            repository.networkManager = resolver.resolve(NetworkManagerInterface.self)
            return repository
        }
        
        container.register(MediaCollectionViewController.self) { resolver in
            let controller = MediaCollectionViewController()
            controller.viewModel = resolver.resolve(MediaCollectionViewModel.self)
            controller.session = resolver.resolve(SessionInterface.self)
            return controller
        }
    }
    
}
