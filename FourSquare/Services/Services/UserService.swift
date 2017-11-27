//
//  UserService.swift
//  FourSquare
//
//  Created by Duy Linh on 5/6/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import Foundation
import FSOAuth
import Alamofire
import ObjectMapper

class UserService: NSObject {
    
    typealias ServiceSuccess = (Void) -> Void
    typealias UserServiceSuccess = (User) -> Void
    
    func login() {
        FSOAuth.authorizeUser(usingClientId: APIKeys.ClientID, nativeURICallbackString: APIKeys.uriCallBack, universalURICallbackString: "", allowShowingAppStore: true)
    }
    
    func getAndSaveToken(accessCode: String?, completion: ServiceSuccess?, failure: Failure? = nil) {
        let clientId = APIKeys.ClientID
        let callbackURI = APIKeys.uriCallBack
        let clientSecret = APIKeys.ClientSecret
        FSOAuth.requestAccessToken(forCode: accessCode, clientId: clientId, callbackURIString: callbackURI, clientSecret: clientSecret) { (authToken, requestCompleted, errorCode) in
            if requestCompleted {
                if errorCode == .none {
                    Session.shared.saveToken(value: authToken)
                    completion?()
                    return
                }
            }
            failure?(NSError.failedLogin())
        }
    }
    
    func loadUserProfile(completion: UserServiceSuccess?, failure: Failure? = nil) {
        api.get(path: ApiPath.userURL, parameters: nil, success: { (response) in
            let user = User()
            if let userObject = response?["user"] as? JSObject {
                if let user = Mapper<User>().map(JSON: userObject) {
                    completion?(user)
                    return
                }
            }
            completion?(user)
        }) { (error) in
            failure?(error)
        }
    }
    
    func postComment(venueId: String, textComment: String, completion: ServiceSuccess?, failure: Failure? = nil) {
        var params: Parameters = Parameters()
        params["venueId"] = venueId
        params["text"] = textComment
        api.post(path: ApiPath.tipURL, parameters: params, success: { (_) in
            completion?()
        }) { (error) in
            failure?(error)
        }
    }
}
