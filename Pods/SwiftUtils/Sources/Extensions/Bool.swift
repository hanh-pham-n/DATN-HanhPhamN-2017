//
//  Bool.swift
//  SwiftUtils
//
//  Created by DaoNV on 10/8/15.
//  Copyright © 2016 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

extension Bool {
    public mutating func toggle() -> Bool {
        self = !self
        return self
    }

    public func toInt() -> Int {
        return self ? 1 : 0
    }
}
