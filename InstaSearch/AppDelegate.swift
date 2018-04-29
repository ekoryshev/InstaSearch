import UIKit

import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let resolver = Assembler([AppAssembly()]).resolver
        
        window?.rootViewController = resolver.resolve(CustomNavigationController.self)!
        window?.makeKeyAndVisible()
        
        return true
    }

}
