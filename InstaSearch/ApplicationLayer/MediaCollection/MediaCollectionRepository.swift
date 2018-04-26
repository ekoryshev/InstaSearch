import Foundation

import Alamofire

class MediaCollectionRepository {
    
    var session: SessionInterface!
    var networkManager: NetworkManagerInterface!
    
    func loadMedia(count: Int, completionHandler: @escaping (Result<MediaResponse?>) -> Void) {
        assert(session.accessToken != nil)
        
        let parameters: [String: Any] = [
            "count": count
        ]
        
        networkManager.request(
            .media,
            method: .get,
            parameters: parameters).startWithResult { response in
                switch response {
                case let .success(value):
                    guard let mediaResponse = ToObject(MediaResponse.self, from: value) else {
                        completionHandler(Result.success(nil))
                        return
                    }
                    
                    completionHandler(Result.success(mediaResponse))
                case let .failure(error):
                    completionHandler(Result.failure(error))
                }
        }
    }
    
    func loadNextMedia(nextURLString: String, completionHandler: @escaping (Result<MediaResponse?>) -> Void) {
        
    }
    
}
