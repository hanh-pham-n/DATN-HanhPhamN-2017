//
//  VenueItemTableViewCell.swift
//  FourSquare
//
//  Created by Duy Linh on 5/2/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit
import SDWebImage

class VenueItemTableViewCell: UITableViewCell {

    // MARK: Define
    private let radiusOfVenueContentView: CGFloat = 4
    private let radiusOfRatingLabel: CGFloat = 10
    private let lineSpace: CGFloat = 6
    
    // MARK: Properties
    @IBOutlet private weak var venueContentView: UIView!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupUI()
    }
    
    // MARK: Private
    private func setupUI() {
        contentView.shadow(color: UIColor.gray, offset: CGSize(width: 2, height: 2), opacity: 0.5, radius: 1)
        venueContentView.layer.cornerRadius = radiusOfVenueContentView
        venueContentView.border(color: UIColor.gray, width: 0.5)
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 4
        thumbnailImageView.contentMode = .scaleAspectFill
        ratingLabel.backgroundColor = Colors.mainColor
        ratingLabel.textColor = UIColor.white
        ratingLabel.layer.cornerRadius = 15
        ratingLabel.clipsToBounds = true
    }
    
    private func descriptionAttributed(string: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        paragraphStyle.lineBreakMode = .byTruncatingTail
        let descriptionAttributed = String.AttributeData(textRange: string,
                                                         attributes: nil,
                                                         attributeItems: [(NSParagraphStyleAttributeName, paragraphStyle)])
        return string.customeAttributedString(data: [descriptionAttributed])
    }
    
    // MARK: Public
    func setupData(venue: Venue) {
        nameLabel.text = venue.name
        addressLabel.attributedText = descriptionAttributed(string: venue.address)
        if let distance = venue.distance, distance != 0 {
            distanceLabel.text = "\(distance)m from here"
        } else {
            distanceLabel.text = "?m from here"
        }
        if let rating = venue.rating {
            ratingLabel.text = "\(rating)"
        } else {
            ratingLabel.backgroundColor = .clear
            ratingLabel.text = ""
        }
        thumbnailImageView.sd_setImage(with: venue.thumbnail?.thumbnailPath)
        thumbnailImageView.contentMode = .scaleAspectFill
    }
}
