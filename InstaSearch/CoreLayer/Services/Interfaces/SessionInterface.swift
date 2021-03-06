import Foundation

protocol SessionInterface {
    
    /// The API token
    var accessToken: String? { get set } // FIXME: Use Keychain!
    
    /// The current user id
    var userID: String? { get set }

    /// The current user name
    var username: String? { get set }
    
    /// The flag indecates authorization status in the app.
    var isAuthorized: Bool { get set }
    
    /// Clears the session.
    func clear()
}
