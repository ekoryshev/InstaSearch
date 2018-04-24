import Foundation

enum Endpoints: String {
    case authorize = "/oauth/authorize"
    case accessToken = "/oauth/access_token"
    case media = "/v1/users/self/media/recent"
}
