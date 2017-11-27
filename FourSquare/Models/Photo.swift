//
//  Photo.swift
//  FourSquare
//
//  Created by Duy Linh on 5/6/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftUtils

class Photo: Mappable {
    
    var prefix: String = ""
    var suffix: String = ""
    var width: Int = 0
    var height: Int = 0
    
    init(prefix: String, suffix: String, width: Int, height: Int) {
        self.prefix = prefix
        self.suffix = suffix
        self.width = width
        self.height = height
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        prefix <- map["prefix"]
        suffix <- map["suffix"]
        width <- map["width"]
        height <- map["height"]
    }
}

extension Photo {
    var avatarPath: URL? {
        let width = 70
        let height = 70
        let path = prefix + "\(width)" + "x" + "\(height)" + suffix
        return URL(string: path)
    }
    
    var userAvatarPath: URL? {
        let width = 500
        let height = 500
        let path = prefix + "\(width)" + "x" + "\(height)" + suffix
        return URL(string: path)
    }
    
    var thumbnailPath: URL? {
        let path = prefix + "\(width / 2)" + "x" + "\(height / 2)" + suffix
        return URL(string: path)
    }
    var photoPathString: URL? {
        let path = prefix + "\(width)" + "x" + "\(height)" + suffix
        return URL(string: path)
    }
}
