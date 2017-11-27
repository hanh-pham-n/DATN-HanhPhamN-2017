//
//  TipsDetailTableViewCell.swift
//  FourSquare
//
//  Created by Duy Linh on 5/4/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit

let dateFormatter: DateFormatter = DateFormatter()

class TipsDetailTableViewCell: UITableViewCell {

    // MARK: Define
    private let cornerRadius: CGFloat = 17.0
    private let lineSpace: CGFloat = 6
    
    // MARK: Properties
    @IBOutlet private(set) weak var userAvatarImageView: UIImageView!
    @IBOutlet private(set) weak var userNameLabel: UILabel!
    @IBOutlet private(set) weak var tipCommentLabel: UILabel!
    @IBOutlet private(set) weak var dateCommentLabel: UILabel!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: Private
    private func setupUI() {
        userAvatarImageView.layer.cornerRadius = cornerRadius
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
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
    func setupData(tip: Tip) {
        userNameLabel.text = tip.userName
        tipCommentLabel.attributedText = descriptionAttributed(string: tip.text)
        userAvatarImageView.sd_setImage(with: tip.userAvatar?.avatarPath)
        let date = Date(timeIntervalSince1970: tip.createdAt)
        dateCommentLabel.text = "\(dateFormatter.string(from: date))"
    }
}
