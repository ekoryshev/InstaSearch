import Foundation

class MediaResponse: Codable {
    var pagination: Pagination
    var data: [Media]
    
    init() {
        pagination = Pagination()
        data = [Media]()
    }
    
    enum CodingKeys: String, CodingKey {
        case pagination
        case data
    }
}
