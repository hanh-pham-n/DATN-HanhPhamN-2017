//
//  DefaultTableViewCell.swift
//  FourSquare
//
//  Created by Duy Linh on 5/4/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var textDetailLabel: UILabel!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
