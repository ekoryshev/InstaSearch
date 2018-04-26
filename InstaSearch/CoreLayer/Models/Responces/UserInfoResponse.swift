import Foundation

class UserInfoResponse: Codable {
    var data: User
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}
