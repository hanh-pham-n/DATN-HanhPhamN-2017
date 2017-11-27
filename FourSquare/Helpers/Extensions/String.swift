//
//  String.swift
//  FourSquare
//
//  Created by Duy Linh on 5/8/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit

extension String {
    struct AttributeData {
        var textRange: String
        var attributes: JSObject?
        var attributeItems: [(String, Any)]
    }
    
    func customeAttributedString(data: [AttributeData]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for attrData in data {
            let rangerString = (self as NSString).range(of: attrData.textRange)
            for item in attrData.attributeItems {
                attributedString.addAttribute(item.0, value: item.1, range: rangerString)
                
            }
            if let attributes = attrData.attributes {
                attributedString.addAttributes(attributes, range: rangerString)
            }
        }
        return attributedString
    }
}
