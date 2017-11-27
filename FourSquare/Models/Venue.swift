//
//  Venue.swift
//  FourSquare
//
//  Created by Duy Linh on 5/6/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftUtils

class Venue: Mappable {
    
    var id: String?
    var name: String?
    var category: String?
    var currency: String = ""
    var rating: Double?
    var ratingColorString: String = ""
    
    var latitude: Double?
    var longitude: Double?
    var address: String = ""
    
    var distance: Int?
    
    var thumbnail: Photo?
    
    var photos: [Photo]?
    var tips: [Tip]?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        category <- map["categories.0.name"]
        
        var tier = 0
        tier <- map["price.tier"]
        for _ in 0..<tier {
            currency += "$"
        }
        rating <- map["rating"]
        ratingColorString <- map["ratingColor"]
        latitude <- map["location.lat"]
        longitude <- map["location.lng"]
        var city: String = ""
        var state: String = ""
        city <- map["location.city"]
        state <- map["location.state"]
        address <- map["location.address"]
        if city == "" {
            address += "\n" + state
        } else {
            address += "\n" + city
            if state != "" {
                address += ", " + state
            }
        }
        if address == "\n" {
            address = Strings.NotAvailable
        }
        distance <- map["location.distance"]
        thumbnail <- map["photos.groups.0.items.0"]
    }
}

extension Venue {
    
    var ratingColor: UIColor {
        return UIColor.hexToColor(hexString: ratingColorString)
    }
}
