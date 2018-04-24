import Foundation

class Image: Codable {
    var width: Int
    var height: Int
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case width
        case height
        case url
    }
}
