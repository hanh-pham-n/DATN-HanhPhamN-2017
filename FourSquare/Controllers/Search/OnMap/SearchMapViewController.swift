//
//  SearchMapViewController.swift
//  FourSquare
//
//  Created by Duy Linh on 5/4/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit

class SearchMapViewController: MapViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if venues.count == 0 {
            venueCollectionView.isHidden = true
            backButton.isHidden = true
            nextButton.isHidden = true
        }
    }
}
