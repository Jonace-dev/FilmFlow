//
//  BaseApiClient.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 30/11/23.
//

import Foundation
import Combine
import Alamofire
import UIKit


class BaseApiClient {
    
    private var isReachable: Bool = true
    private lazy var sesionManager = Session(configuration: URLSessionConfiguration.default)
    
    private var baseURL: URL {
        if let url = URL(string: Environment.shared.baseURL) {
            return url
        } else {
            print("error.url.invalid")
            return URL(string: "")!
        }
    }
    
    private var token: String {
        Environment.shared.token
    }
    
    private var apiKey: String {
        Environment.shared.apiKey
    }
    
    init() {
        startListenerReachability()
    }
    
    func requestPublisher<T: Decodable>(_ relativePath: String?,
                                        method: HTTPMethod = .get,
                                        parameters: Parameters? = nil,
                                        urlEncoding: ParameterEncoding = URLEncoding.default,
                                        type: T.Type = T.self,
                                        customHeaders: HTTPHeaders? = nil) -> AnyPublisher<T, BaseError> {
        
        guard let path = relativePath, let urlAbsolute = baseURL.appendingPathComponent(path).absoluteString.removingPercentEncoding else {
            return Fail(error: BaseError.generic).eraseToAnyPublisher()
        }
        
        let parameters: Parameters? = (parameters == nil) ? defaultParameters() : parameters
        let headers: HTTPHeaders? = (customHeaders == nil) ? defaultHeaders() : customHeaders
        
        print("URL => \(urlAbsolute)")
        return sesionManager.request(urlAbsolute, method: method, parameters: parameters, encoding: urlEncoding, headers: headers)
            .validate()
            #if DEBUG
            .cURLDescription(on: .main, calling: { p in print(p) })
            #endif
            .publishDecodable(type: T.self)
            .tryMap({ response in
                switch response.result {
                case let .success(result):
                    return result
                case let .failure(error):
                    
                    print(error.errorDescription ?? "error")
                    let codeHttpResponse = response.response?.statusCode ?? 400
                    let errorHttp = codeHttpResponse > 299 || codeHttpResponse < 200
                    
                    if let apiError = self.handler(error: error, errorCode: codeHttpResponse), errorHttp {
                        throw apiError
                    } else {
                        throw BaseError.generic
                    }
                }
            })
            .mapError({ $0 as? BaseError ?? .generic})
            .eraseToAnyPublisher()
    }
    
    func handler(error: Error?, errorCode: Int) -> BaseError? {
        
        if !self.isReachable { return BaseError.noInternetConnection }
        var baseError: BaseError?
        
        if error != nil {
            baseError = BaseError.API(APIError(errorCode: "\(errorCode)", localizedMessage: error?.localizedDescription))
        }
        
        return baseError
    }
    
    private func startListenerReachability() {
        
        let net = NetworkReachabilityManager()
        net?.startListening(onUpdatePerforming: {  _ in
            if net?.isReachable ?? false {
                self.isReachable = true
                
            } else {
                self.isReachable = false
            }
        })
    }
    
    private func defaultHeaders() -> HTTPHeaders {
        ["accept": "application/json",
         "Authorization": "Bearer \(token)"]
    }
    
    private func defaultParameters() -> Parameters {
        ["api_key": "\(apiKey)"]
    }
    
    func setAuthToken(_ values: [String: String]) -> [String: String] {
        
        let token = token
        
        var headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        let _ = values.map { (key, value) in
            headers[key] = value
        }
        
        return headers
    }
}
