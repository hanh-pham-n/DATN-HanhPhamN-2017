//
//  User.swift
//  FourSquare
//
//  Created by Duy Linh on 5/6/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftUtils

class User: Mappable {
    
    var name: String?
    var gender: String?
    var avatar: Photo?
    var countTips: Int?
    var homeCity: String?
    var phone: String?
    var email: String?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        var firstName: String = ""
        firstName <- map["firstName"]
        var lastName: String = ""
        lastName <- map["lastName"]
        name = firstName + " " + lastName
        gender <- map["gender"]
        avatar <- map["photo"]
        countTips <- map["tips.count"]
        homeCity <- map["homeCity"]
        phone <- map["contact.phone"]
        email <- map["contact.email"]
    }
}
