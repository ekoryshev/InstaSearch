import Foundation

protocol ConfigurationInterface {
    var apiURL: String! { get }
    var instaClientID: String! { get }
    var instaClientSecret: String! { get }
    var instaRedirectURL: String! { get }
}
