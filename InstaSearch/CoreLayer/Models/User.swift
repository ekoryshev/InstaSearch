import Foundation

class User: Codable {
    var id: String
    var username: String
    var profilePicture: String
    var fullName: String
    var bio: String
    var isBusiness: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case profilePicture = "profile_picture"
        case fullName = "full_name"
        case bio
        case isBusiness = "is_business"
    }
}
