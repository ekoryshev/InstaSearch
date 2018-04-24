import Foundation

private enum Key {
    static let configuration = "Configuration"
    static let apiURL = "IS_API_URL"
    static let instaClientID = "IS_INSTA_CLIENT_ID"
    static let instaClientSecret = "IS_INSTA_CLIENT_SECRET"
    static let instaRedirectURL = "IS_INSTA_REDIRECT_URL"
}

class Configuration: ConfigurationInterface {
    
    static let shared = Configuration()

    var apiURL: String! {
        return configuration?[Key.apiURL] ?? ""
    }
    
    var instaClientID: String! {
        return configuration?[Key.instaClientID] ?? ""
    }
    
    var instaClientSecret: String! {
        return configuration?[Key.instaClientSecret] ?? ""
    }
    
    var instaRedirectURL: String! {
        return configuration?[Key.instaRedirectURL] ?? ""
    }

    fileprivate var configuration: [String: String]?
    
    init() {
        configuration = Bundle.main.object(forInfoDictionaryKey: Key.configuration) as? [String: String]
    }
}
