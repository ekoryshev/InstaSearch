import Foundation

import ReactiveSwift
import Result

class AuthorizationViewModel: MVVMViewModel {

    var repository: AuthorizationRepository!
    
    // MARK: Signals
    
    typealias CloseModuleSignal = Signal<Void, NoError>
    let closeModuleSignal: CloseModuleSignal
    private var closeModuleObserver: CloseModuleSignal.Observer
    
    // MARK: Initialization
    
    override init() {
        (closeModuleSignal, closeModuleObserver) = CloseModuleSignal.pipe()
    }
    
    // MARK: Public Methods
    
    func authorize() {
        loading.value = true
        repository.authorize { [weak self] result in
            // TODO: Handle nil result
            switch result {
            case let .success(value):
                print("username: \(value?.data.username ?? "")")
                self?.closeModuleObserver.send(value: ())
            case let .failure(error):
                print("error: \(error.localizedDescription)")
                self?.processError(error)
            }
            
            self?.loading.value = false
        }
    }
    
    func getAuthorizationURL() -> URL? {
        guard let configuration = configuration else {
            return nil
        }

        let urlString = ["\(configuration.apiURL!)\(Endpoints.authorize.rawValue)",
            "/?client_id=\(configuration.instaClientID!)&redirect_uri=",
            "\(configuration.instaRedirectURL!)&response_type=token"].joined()
        
        return URL(string: urlString)
    }
 
    // http://yourcallback.com/#access_token=2198211652.5181f21.4a041ccd0ece4fa085395f8a892bd5f0
    func extractToken(_ url: URL) -> String? {
        return extractValue(url: url, param: "access_token=", separator: "#")
    }
    
    // swiftlint:disable:next line_length
    // http://yourcallback.com/?error_reason=user_denied&error=access_denied&error_description=The+user+denied+your+request.
    func extractError(_ url: URL) -> String? {
        return extractValue(url: url, param: "error=", separator: "&")
    }
    
    // MARK: Private Methods
    
    fileprivate func extractValue(url: URL, param: String, separator: String) -> String? {
        var value: String? = nil
        let urlQuery = (url.query != nil) ? url.query : url.relativeString
        let components = urlQuery?.components(separatedBy: separator)
        for comp in components! {
            if comp.range(of: param) != nil {
                value = comp.components(separatedBy: "=").last
            }
        }
        return value
    }
    
}
