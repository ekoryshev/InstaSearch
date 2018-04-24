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
    
    func authorize(code: String) {
        loading.value = true
        repository.authorize(code: code) { [weak self] result in
            switch result {
            case let .success(value):
                print("username: \(value?.user.username ?? "")")
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
        
        let urlString = "\(configuration.apiURL!)\(Endpoints.authorize.rawValue)/?client_id=\(configuration.instaClientID!)&redirect_uri=\(configuration.instaRedirectURL!)&response_type=code"
        return URL(string: urlString)
    }
 
    // http://yourcallback.com/?code=8075aa634f1049709e536a5c531bd46e
    func extractCode(_ url: URL) -> String? {
        return extractValue(url, "code=")
    }
    
    // http://yourcallback.com/?error_reason=user_denied&error=access_denied&error_description=The+user+denied+your+request.
    func extractError(_ url: URL) -> String? {
        return extractValue(url, "error=")
    }
    
    // MARK: Private Methods
    
    fileprivate func extractValue(_ url: URL, _ param: String) -> String? {
        var value: String? = nil
        let urlQuery = (url.query != nil) ? url.query : url.relativeString
        let components = urlQuery?.components(separatedBy: "&")
        for comp in components! {
            if (comp.range(of: param) != nil) {
                value = comp.components(separatedBy: "=").last
            }
        }
        return value
    }
    
}
