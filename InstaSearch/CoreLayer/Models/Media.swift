import Foundation

class Media: Codable {
    var id: String
    var user: User
    var images: Images
    var createdTime: String
    var caption: Caption
    var userHasLiked: Bool
    var likes: Likes
    var comments: Comments
    var type: String // "image"
    
    enum CodingKeys: String, CodingKey {
        case id
        case user
        case images
        case createdTime = "created_time"
        case caption
        case userHasLiked = "user_has_liked"
        case likes
        case comments
        case type
    }
}
