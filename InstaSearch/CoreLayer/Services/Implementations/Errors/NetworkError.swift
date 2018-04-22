import Foundation

enum NetworkError: LocalizedError {
    case lostConnection
    
    var errorDescription: String? {
        switch self {
        case .lostConnection:
            return LocalizedString("connection.error")
        }
    }
}
