import Foundation

class AuthorizationResponse: Codable {
    var accessToken: String
    var user: User
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case user
    }
}
