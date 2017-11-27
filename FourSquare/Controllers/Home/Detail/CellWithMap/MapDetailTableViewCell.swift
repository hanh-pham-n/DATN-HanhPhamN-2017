//
//  MapDetailTableViewCell.swift
//  FourSquare
//
//  Created by Duy Linh on 5/4/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit

protocol MapDetailTableViewCellDelegate: NSObjectProtocol {
    
    func showMapDetailVenue()
}

class MapDetailTableViewCell: UITableViewCell {

    // MARK: Define
    private let lineSpace: CGFloat = 6.0
    // MARK: Properties
    @IBOutlet private(set) weak var addressLabel: UILabel!
    weak var delegate: MapDetailTableViewCellDelegate?
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Private
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
    func setupDate(string: String) {
        addressLabel.attributedText = descriptionAttributed(string: string)
    }
    
    // MARK: Action
    @IBAction func mapDetailAction(_ sender: Any) {
        delegate?.showMapDetailVenue()
    }
}
