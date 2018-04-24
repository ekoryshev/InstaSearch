import Foundation

enum InstagramAPIError: LocalizedError {
    case error(value: String)
    
    var errorDescription: String? {
        switch self {
        case let .error(value):
            return LocalizedString(value)
        }
    }
}
