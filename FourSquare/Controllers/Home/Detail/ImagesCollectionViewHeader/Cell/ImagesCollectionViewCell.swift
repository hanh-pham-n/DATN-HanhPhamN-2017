//
//  ImagesCollectionViewCell.swift
//  FourSquare
//
//  Created by Duy Linh on 5/4/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    @IBOutlet private weak var venueImageView: UIImageView!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Public
    func setupData(photo: Photo) {
        venueImageView.sd_setImage(with: photo.photoPathString)
    }
}
