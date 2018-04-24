import Foundation

/// The Session uses for storing all user data.
class Session: SessionInterface {
    
    /// The Keys describes all keys for storing data.
    enum Keys {
        static let accessToken = "accessToken"
        static let userID = "userID"
        static let username = "username"
        static let authorized = "authorized"
    }
    
    /// The shared store for the Session.
    static var shared = Session(inStore: UserDefaults(suiteName: "app.session.store"))
    
    /// The API token
    var accessToken: String? { // FIXME: Use Keychain!
        get {
            return store.object(forKey: Keys.accessToken) as? String
        }
        set {
            store.set(newValue, forKey: Keys.accessToken)
            store.synchronize()
        }
    }
    
    /// The current user id
    var userID: String? {
        get {
            return store.object(forKey: Keys.userID) as? String
        }
        set {
            store.set(newValue, forKey: Keys.userID)
            store.synchronize()
        }
    }
    
    /// The current user name
    var username: String? {
        get {
            return store.object(forKey: Keys.username) as? String
        }
        set {
            store.set(newValue, forKey: Keys.username)
            store.synchronize()
        }
    }
    
    /// The flag indecates authorization status in the app.
    var isAuthorized: Bool {
        get {
            return store.object(forKey: Keys.authorized) as? Bool ?? false
        }
        set {
            store.set(newValue, forKey: Keys.authorized)
            store.synchronize()
        }
    }
    
    private var store: UserDefaults!
    
    init(inStore store: UserDefaults?) {
        self.store = store ?? UserDefaults(suiteName: "app.session.store")
    }
    
    // MARK: Public Methods
    
    func clear() {
        for (key, _) in store.dictionaryRepresentation() {
            store.removeObject(forKey: key)
        }
        store.synchronize()
    }
}
