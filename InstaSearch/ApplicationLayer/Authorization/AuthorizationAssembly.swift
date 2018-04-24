import UIKit

import Swinject

class AuthorizationAssembly: MVVMAssembly {
    
    override func assemble(container: Container) {
        super.assemble(container: container)
        
        container.register(AuthorizationViewModel.self) { resolver in
            let viewModel = AuthorizationViewModel()
            viewModel.configuration = resolver.resolve(ConfigurationInterface.self)
            viewModel.repository = resolver.resolve(AuthorizationRepository.self)
            return viewModel
        }
        
        container.register(AuthorizationRepository.self) { resolver in
            let repository = AuthorizationRepository()
            repository.session = resolver.resolve(SessionInterface.self)
            repository.configuration = resolver.resolve(ConfigurationInterface.self)
            repository.networkManager = resolver.resolve(NetworkManagerInterface.self)
            return repository
        }
        
        container.register(AuthorizationViewController.self) { resolver in
            let controller = AuthorizationViewController()
            controller.viewModel = resolver.resolve(AuthorizationViewModel.self)
            return controller
        }
        
        container.register(CustomNavigationController.self) { resolver in
            let navController = CustomNavigationController(
                rootViewController: resolver.resolve(AuthorizationViewController.self)!)
            return navController
        }
    }
    
}
