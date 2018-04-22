import Foundation

import Alamofire
import ReactiveSwift
import struct Result.AnyError

protocol NetworkManagerInterface {
    
    func request(
        _ endpoint: Endpoints,
        method: HTTPMethod,
        parameters: Parameters
        ) -> SignalProducer<Data, AnyError>
    
    func request(
        _ endpoint: Endpoints,
        method: HTTPMethod,
        parameters: Parameters,
        completionHandler: @escaping (Result<Data>) -> Void
    )
}

extension NetworkManagerInterface {
    
    func request(
        _ endpoint: Endpoints,
        method: HTTPMethod,
        parameters: Parameters
        ) -> SignalProducer<Data, AnyError> {
        
        return request(endpoint, method: method, parameters: parameters)
    }
    
    func request(
        _ endpoint: Endpoints,
        method: HTTPMethod = .get,
        parameters: Parameters = [:],
        completionHandler: @escaping (Result<Data>) -> Void
        ) {
        
        request(endpoint, method: method, parameters: parameters, completionHandler: completionHandler)
    }
}
