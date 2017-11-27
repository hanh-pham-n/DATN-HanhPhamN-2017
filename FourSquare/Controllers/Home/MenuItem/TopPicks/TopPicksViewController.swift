//
//  TopPicksViewController.swift
//  FourSquare
//
//  Created by Duy Linh on 5/2/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit

class TopPicksViewController: MenuItemViewController {
    
    override var section: SectionQuery {
        return .TopPicks
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVenue()
    }
    
    override func setupUI() {
        super.setupUI()
    }
}
