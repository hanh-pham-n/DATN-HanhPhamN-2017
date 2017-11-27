//
//  SearchListViewController.swift
//  FourSquare
//
//  Created by Duy Linh on 5/4/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit
import SwiftUtils

class SearchListViewController: MenuItemViewController {

    override var frameTableView: CGRect {
        return CGRect(x: 0, y: 0, width: kScreenSize.width, height: kScreenSize.height - 321)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isVenueEmpty = true
    }
    
    override func setupUI() {
        super.setupUI()
        venueTableView.backgroundColor = UIColor.clear
    }
    
    override func addPullToRefresh() {
    }
    
    override func addInfiniteScrolling() {
    }
}
