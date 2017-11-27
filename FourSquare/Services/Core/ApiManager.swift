//
//  ApiManager.swift
//  FourSquare
//
//  Created by Duy Linh on 5/5/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftUtils

typealias JSObject = [String: AnyObject]
typealias JSArray = [JSObject]
typealias Completion = (Result<AnyObject>) -> Void
typealias Failure = (NSError?) -> Void
typealias Success = (JSObject?) -> Void

let api: ApiManager = ApiManager()

class ApiManager {
    
    private func request(path: String,
                         method: HTTPMethod,
                         parameters: Parameters? = nil,
                         encoding: ParameterEncoding = URLEncoding.default,
                         success: Success? = nil,
                         failure: Failure? = nil) -> Request? {
        
        // Check network status
        
        if let reachability = NetworkReachabilityManager(), reachability.networkReachabilityStatus == .notReachable {
            failure?(NSError.network())
            return nil
        }
        
        // Validate URL
        
        guard let url = URL(string: path) else {
            failure?(NSError.invalidURL())
            return nil
        }
        
        let header: [String: String] = [:]
        var params: Parameters? = Parameters()
        if parameters != nil {
            params = parameters
        }
        if let accessToken = Session.shared.token() {
            params?["oauth_token"] = accessToken
        } else {
            params?["client_id"] = APIKeys.ClientID
            params?["client_secret"] = APIKeys.ClientSecret
        }
        params?["v"] = APIKeys.VersionAPI
        
        let request = Alamofire.request(url, method: method, parameters: params, encoding: encoding, headers: header)
        request.validate().responseJSON { (response) in
            if response.result.isSuccess {
                guard let result = response.result.value as? JSObject else {
                    failure?(response.error as NSError?)
                    return
                }
                guard let meta = result["meta"] as? JSObject else {
                    failure?(NSError.unknow())
                    return
                }
                guard let code = meta["code"] as? Int else {
                    failure?(NSError.unknow())
                    return
                }
                if code != 200 {
                    guard let errorType = meta["errorType"] as? String, let errorDetail = meta["errorDetail"] as? String else {
                        failure?(NSError.unknow())
                        return
                    }
                    let error = NSError(message: "\(errorType): \(errorDetail)")
                    failure?(error)
                } else {
                    guard let response = result["response"] as? JSObject else {
                        failure?(NSError.unknow())
                        return
                    }
                    success?(response)
                }
            } else {
                if let error = response.error as NSError? {
                    failure?(error)
                } else {
                    failure?(NSError.unknow())
                }
            }
        }
        
        return request
    }
    
    // MARK: Public functions
    
    @discardableResult func  get(path: String, parameters: Parameters? = nil, success: Success?, failure: Failure? = nil) -> Request? {
        return request(path: path, method: .get, parameters: parameters, success: success, failure: failure)
    }
    
    @discardableResult func post(path: String, parameters: Parameters? = nil, success: Success?, failure: Failure? = nil) -> Request? {
        return request(path: path, method: .post, parameters: parameters, success: success, failure: failure)
    }
    
    @discardableResult func put(path: String, parameters: Parameters? = nil, success: Success?, failure: Failure? = nil) -> Request? {
        return request(path: path, method: .put, parameters: parameters, success: success, failure: failure)
    }
    
    @discardableResult func delete(path: String, parameters: Parameters? = nil, success: Success?, failure: Failure? = nil) -> Request? {
        return request(path: path, method: .delete, parameters: parameters, success: success, failure: failure)
    }
}

// MARK: NSError

extension NSError {
    
    class func network() -> NSError {
        return NSError(message: "No network connection")
    }
    
    class func invalidURL() -> NSError {
        return NSError(message: "Invalid URL")
    }
    
    class func unknow() -> NSError {
        return NSError(message: "Unknow error")
    }
    
    class func failedLogin() -> NSError {
        return NSError(message: "Login Failed")
    }
    
    class func locationService() -> NSError {
        return NSError(message: "No Location Services")
    }
}
