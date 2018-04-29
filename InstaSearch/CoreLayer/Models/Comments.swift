import Foundation

class Comments: Codable {
    var count: Int
    
    enum CodingKeys: String, CodingKey {
        case count
    }
}
