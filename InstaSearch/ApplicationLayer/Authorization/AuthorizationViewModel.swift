import Foundation

class AuthorizationViewModel: MVVMViewModel {
    
    var repository: AuthorizationRepository!
 
    func extractCode(_ url: URL) -> String? {
        var code: String? = nil
        let urlQuery = (url.query != nil) ? url.query : url.relativeString
        let components = urlQuery?.components(separatedBy: "&")
        for comp in components! {
            if (comp.range(of: "code=") != nil) {
                code = comp.components(separatedBy: "=").last
            }
        }
        return code
    }
    
}
