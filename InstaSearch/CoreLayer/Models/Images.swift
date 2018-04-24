import Foundation

class Images: Codable {
    var thumbnail: Image
    var lowResolution: Image
    var standardResolution: Image
    
    enum CodingKeys: String, CodingKey {
        case thumbnail
        case lowResolution = "low_resolution"
        case standardResolution = "standard_resolution"
    }
}
