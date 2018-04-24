import Foundation

import Alamofire

class AuthorizationRepository {
    
    var configuration: ConfigurationInterface!
    var networkManager: NetworkManagerInterface!
    
    func loadAuthorizationURL(completionHandler: @escaping (Result<Void>) -> Void) {
        let parameters: [String: Any] = [
            "client_id": configuration.instaClientID,
            "redirect_uri": configuration.instaRedirectURL,
            "response_type": "code",
        ]
        
        networkManager.request(.authorize, method: .get, parameters: parameters) { response in
            switch response {
            case .success:
                completionHandler(Result.success(()))
            case let .failure(error):
                completionHandler(Result.failure(error))
            }
        }
    }
    
}
