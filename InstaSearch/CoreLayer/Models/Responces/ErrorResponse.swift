import Foundation

class ErrorResponse: Codable {
    var errorType: String
    var code: Int
    var errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case errorType = "error_type"
        case code
        case errorMessage = "error_message"
    }
}
