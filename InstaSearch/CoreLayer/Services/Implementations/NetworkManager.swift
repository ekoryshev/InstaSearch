import Foundation

import Alamofire
import ReactiveSwift
import struct Result.AnyError

class NetworkManager: NetworkManagerInterface {
    
    // MARK: Injection
    
    var session: SessionInterface! {
        didSet {
            configureAlamofire()
        }
    }
    var configuration: ConfigurationInterface!
    
    private let alamofire = Alamofire.SessionManager()
    
    // MARK: Public Methods
    
    func request(
        _ endpoint: Endpoints,
        method: HTTPMethod,
        parameters: Parameters
        ) -> SignalProducer<Data, AnyError> {
        return SignalProducer<Data, AnyError> { [weak self] observer, _ in
            self?.request(endpoint, method: method, parameters: parameters, completionHandler: { result in
                switch result {
                case let .success(value):
                    observer.send(value: value)
                    observer.sendCompleted()
                case let .failure(error):
                    observer.send(error: AnyError(error))
                    observer.sendCompleted()
                }
            })
        }
    }
    
    func request(
        _ endpoint: Endpoints,
        method: HTTPMethod,
        parameters: Parameters,
        completionHandler: @escaping (Result<Data>) -> Void
        ) {
        printEndpoint(endpoint, method: method, parameters: parameters)
        
        let urlEncodingType = URLEncoding.default as ParameterEncoding
        let jsonEncodingType = JSONEncoding.default as ParameterEncoding
        let encoding = method == .get ? urlEncodingType : jsonEncodingType
        
        let parameters = !parameters.isEmpty ? parameters : nil
        let url = configuration.apiURL!
        let request = alamofire.request(
            url + endpoint.rawValue,
            method: method,
            parameters: parameters,
            encoding: encoding
        )
        request.validate(statusCode: 200..<300)
        request.validate(contentType: [ "application/json" ])
        request.responseData { response in
            switch response.result {
            case .success:
                completionHandler(response.result)
            case let .failure(error):
                debugLog("----------------------------------------------------------------------------------------")
                debugLog("\(method.rawValue.uppercased()): \(endpoint.rawValue)")
                debugLog("\(error.localizedDescription)")
                if let value = ToObject(ErrorResponse.self, from: response.data) {
                    debugLog("{ \n  \"code\": \(value.code), \n  \"message\": \(value.message) \n}")
                    completionHandler(Result<Data>.failure(ErrorHelper.toApplication(from: value)))
                } else {
                    completionHandler(Result<Data>.failure(NetworkError.lostConnection))
                }
                debugLog("----------------------------------------------------------------------------------------")
            }
        }
    }
    
    // MARK: Private Methods
    
    private func configureAlamofire() {
        alamofire.adapter = TokenAdapter(withSession: session)
        alamofire.session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    }
    
    private func printEndpoint(_ endpoint: Endpoints, method: HTTPMethod, parameters: [AnyHashable: Any]) {
        #if DEBUG
            do {
                let data = try JSONSerialization.data(withJSONObject: parameters, options: [ .prettyPrinted ])
                if let parametersString = String(data: data, encoding: .utf8) {
                    debugLog("\(method.rawValue.uppercased()): \(endpoint.rawValue)")
                    debugLog(parametersString)
                }
            } catch let error {
                debugLog("Couldn't serialize the request parameters: \(error)")
            }
        #endif
    }
    
    // MARK: Request Adapter Implementation
    
    private class TokenAdapter: RequestAdapter {
        let session: SessionInterface!
        
        init(withSession session: SessionInterface!) {
            self.session = session
        }
        
        func adapt(_ request: URLRequest) throws -> URLRequest {
            var request = request
            request.setValue(session.token ?? nil, forHTTPHeaderField: "Authorization")
            return request
        }
    }
    
    // MARK: Error Helper Implementation
    
    private class ErrorHelper {
        static func toApplication(from error: ErrorResponse?) -> Error {
            if let error = error {
                return APIError.error(value: error.message)
            }
            return NetworkError.lostConnection
        }
    }
}
