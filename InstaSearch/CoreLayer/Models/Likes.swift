import Foundation

class Likes: Codable {
    var count: Int
    
    enum CodingKeys: String, CodingKey {
        case count
    }
}
