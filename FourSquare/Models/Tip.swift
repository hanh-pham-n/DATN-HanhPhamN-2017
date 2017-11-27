//
//  Tip.swift
//  FourSquare
//
//  Created by Duy Linh on 5/6/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftUtils

class Tip: Mappable {
    
    var id: String?
    var userName: String = ""
    var text: String = ""
    var createdAt: Double = 0
    var userAvatar: Photo?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        var firstName: String = ""
        firstName <- map["user.firstName"]
        var lastName: String = ""
        lastName <- map["user.lastName"]
        userName = firstName + " " + lastName
        text <- map["text"]
        createdAt <- map["createdAt"]
        userAvatar <- map["user.photo"]
    }
}
