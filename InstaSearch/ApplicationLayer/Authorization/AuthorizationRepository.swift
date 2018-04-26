import Foundation

import Alamofire

class AuthorizationRepository {
    
    var session: SessionInterface!
    var configuration: ConfigurationInterface!
    var networkManager: NetworkManagerInterface!

    func authorize(completionHandler: @escaping (Result<UserInfoResponse?>) -> Void) {
        networkManager.request(
            .userInfo,
            method: .get,
            parameters: [String: Any]()).startWithResult { [weak self] response in
            switch response {
            case let .success(value):
                guard let userInfoResponse = ToObject(UserInfoResponse.self, from: value) else {
                    self?.session.userID = nil
                    self?.session.username = nil
                    self?.session.isAuthorized = false
                    
                    completionHandler(Result.success(nil))
                    return
                }
                
                self?.session.userID = userInfoResponse.data.id
                self?.session.username = userInfoResponse.data.username
                self?.session.isAuthorized = true

                completionHandler(Result.success(userInfoResponse))
            case let .failure(error):
                completionHandler(Result.failure(error))
            }
        }
    }
    
}
