import Foundation

enum Endpoints: String {
    case authorize = "/oauth/authorize"
    case userInfo = "/v1/users/self"
    case media = "/v1/users/self/media/recent"
}
