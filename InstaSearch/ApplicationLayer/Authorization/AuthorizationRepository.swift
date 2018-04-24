import Foundation

import Alamofire

class AuthorizationRepository {
    
    var session: SessionInterface!
    var configuration: ConfigurationInterface!
    var networkManager: NetworkManagerInterface!
    
    func authorize(code: String, completionHandler: @escaping (Result<AuthorizationResponse?>) -> Void) {
        let parameters: [String: Any] = [
            "client_id": configuration.instaClientID,
            "client_secret": configuration.instaClientSecret,
            "grant_type": "authorization_code",
            "redirect_uri": configuration.instaRedirectURL,
            "code": code
        ]
        
        networkManager.request(
            .accessToken,
            method: .post,
            parameters: parameters).startWithResult { [weak self] response in
            switch response {
            case let .success(value):
                guard let authorizationResponse = ToObject(AuthorizationResponse.self, from: value) else {
                    self?.session.accessToken = nil
                    self?.session.userID = nil
                    self?.session.username = nil
                    self?.session.isAuthorized = false
                    
                    completionHandler(Result.success(nil))
                    return
                }
                
                self?.session.accessToken = authorizationResponse.accessToken
                self?.session.userID = authorizationResponse.user.id
                self?.session.username = authorizationResponse.user.username
                self?.session.isAuthorized = true

                
                // TODO: Get information about the owner of the access_token.
                // GET /users/self

                completionHandler(Result.success(authorizationResponse))
            case let .failure(error):
                completionHandler(Result.failure(error))
            }
        }
    }
    
}
