//
//  Session.swift
//  FourSquare
//
//  Created by Duy Linh on 5/5/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import Foundation

let kAccessToken = "kAccessToken"

class Session {
    
    // MARK: Private Properties
    
    private let defaults = UserDefaults.standard
    
    // MARK: Public properties
    
    static let shared = Session()
    
    // MARK: Public functions
    
    func logout() {
        defaults.removeObject(forKey: kAccessToken)
    }
    
    func saveToken(value: String?) {
        defaults.set(value, forKey: kAccessToken)
    }
    
    func token() -> String? {
        return defaults.string(forKey: kAccessToken)
    }
}
