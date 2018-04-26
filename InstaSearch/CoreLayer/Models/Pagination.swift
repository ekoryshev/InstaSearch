import Foundation

class Pagination: Codable {
    var nextMaxID: String
    var nextURL: String
    
    enum CodingKeys: String, CodingKey {
        case nextMaxID = "next_max_id"
        case nextURL = "next_url"
    }
}
