import Foundation

class Caption: Codable {
    var id: String
    var text: String
    var createdTime: String
    var from: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case createdTime = "created_time"
        case from
    }
}
