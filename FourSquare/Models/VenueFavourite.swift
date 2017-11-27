//
//  VenueFavourite.swift
//  FourSquare
//
//  Created by Duy Linh on 5/11/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftUtils
import RealmSwift

class VenueFavourite: Object {
    
    dynamic var id: String?
    dynamic var name: String?
    dynamic var category: String?
    dynamic var currency: String = ""
    dynamic var rating: Double = 0.0
    dynamic var ratingColorString: String = ""
    
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var address: String = ""
    
    dynamic var distance: Int = 0
    
    dynamic var thumbnailPrefix: String = ""
    dynamic var thumbnailSuffix: String = ""
    dynamic var thumbnailWidth: Int = 0
    dynamic var thumbnailHeight: Int = 0
    
    dynamic var favoriteTimestamp = Date()
}

extension VenueFavourite {
    
    var ratingColor: UIColor {
        return UIColor.hexToColor(hexString: ratingColorString)
    }
}
