//
//  NSCache.swift
//  SwiftUtils
//
//  Created by DaoNV on 8/23/16.
//  Copyright © 2016 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

extension NSCache {
    public convenience init(name: String, totalCostLimit: Int = 0, countLimit: Int = 0) {
        self.init()
        self.name = name
        self.totalCostLimit = totalCostLimit
        self.countLimit = countLimit
    }
}
