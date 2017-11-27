//
//  BasicContentView.swift
//  FourSquare
//
//  Created by Duy Linh on 4/25/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit

class BasicContentView: TabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        highlightTextColor = Colors.mainColor
        iconColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        highlightIconColor = Colors.mainColor
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
