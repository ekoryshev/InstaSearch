import Foundation

class ErrorResponse: Codable {
    var meta: ErrorInfo
    
    enum CodingKeys: String, CodingKey {
        case meta
    }
}
