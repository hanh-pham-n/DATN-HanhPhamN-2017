//
//  VenueDetailViewController.swift
//  FourSquare
//
//  Created by Duy Linh on 5/3/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit
import SVPullToRefresh
import SwiftUtils

class VenueDetailViewController: BaseViewController {
    
    // MARK: Define
    enum DetailVenueSection: Int {
        case PageImage = 0
        case Information
        case Tips
        
        var title: String {
            switch self {
            case .PageImage:
                return ""
            case .Information:
                return Strings.DetailVenueTitleInformation
            case .Tips:
                return Strings.DetailVenueTitleTips
            }
        }
        
        var sectionHeight: CGFloat {
            switch self {
            case .PageImage:
                return 250
            default:
                return 30
            }
        }
    }
    
    enum InfomationSection: Int {
        case Name
        case Address
        case Categories
        case Rating
        
        var title: String {
            switch self {
            case .Name:
                return Strings.InfomationTitleName
            case .Address:
                return Strings.InfomationTitleAddress
            case .Categories:
                return Strings.InfomationTitleCategories
            case .Rating:
                return Strings.InfomationTitleRating
            }
        }
    }
    
    // MARK: Properties
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var heightViewCommentLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomViewCommentLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var commentTextView: UITextView!
    @IBOutlet fileprivate weak var postCommentButton: UIButton!
    private let venueService = VenueService()
    private var offset: Int = 0
    private var lastIndex: Int = 10
    private var isFavourite: Bool = false
    private var shortUrl: String = ""
    fileprivate var tips: [Tip] = []
    var venue: Venue?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewComment()
        getShortUrl()
        loadPhotosVenue()
        loadTipsVenue()
    }
    
    override func setupUI() {
        super.setupUI()
        commentTextView.layer.cornerRadius = 4.0
        commentTextView.border(color: UIColor.RGB(160, 160, 160), width: 1)
        commentTextView.delegate = self
        addFavouriteButtonItem()
        setupTableView()
    }
    
    // MARK: Private
    private func addViewComment() {
        if let _ = Session.shared.token() {
            heightViewCommentLayoutConstraint.constant = 50
        } else {
            heightViewCommentLayoutConstraint.constant = 0
        }
    }
    
    private func addFavouriteButtonItem() {
        if let id = venue?.id {
            isFavourite = RealmManager.shared.isFavourite(id: id)
        }
        let imageString = isFavourite ? "ic_favourite_yes" : "ic_favourite_no"
        let favouriteButtonItem = UIBarButtonItem(image: UIImage(named: imageString), style: .done, target: self, action: #selector(saveFavouriteAction))
        let shareButtonItem = UIBarButtonItem(image: UIImage(named: "ic_share_facebook"), style: .done, target: self, action: #selector(shareFacbookAction))
        navigationItem.setRightBarButtonItems([favouriteButtonItem, shareButtonItem], animated: true)
        navigationItem.rightBarButtonItems?.first?.tintColor = isFavourite ? Colors.Orange253 : nil
    }
    
    @objc private func saveFavouriteAction() {
        if !isFavourite, let venue = venue {
            let venueFavourite = convertVenueFavourite(venue: venue)
            RealmManager.shared.addVenueFavourite(venueFavourite: venueFavourite)
        } else {
            if let id = venue?.id {
                RealmManager.shared.deleteVenueFavorite(id: id)
            }
        }
        isFavourite = !isFavourite
        let imageString = isFavourite ? "ic_favourite_yes" : "ic_favourite_no"
        navigationItem.rightBarButtonItems?.first?.image = UIImage(named: imageString)
        navigationItem.rightBarButtonItems?.first?.tintColor = isFavourite ? Colors.Orange253 : nil
        var userInfor: [String : Any] = [:]
        userInfor["venueID"] = venue?.id
        let notificationName = Notification.Name(rawValue: NotificationCenterKey.LoadVenueFavourite)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfor)
    }
    
    @objc private func shareFacbookAction() {
        let activityViewController = UIActivityViewController(activityItems: [shortUrl], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    private func convertVenueFavourite(venue: Venue) -> VenueFavourite {
        let venueFavourite: VenueFavourite = VenueFavourite()
        venueFavourite.id = venue.id
        venueFavourite.name = venue.name
        venueFavourite.category = venue.category
        venueFavourite.currency = venue.currency
        if let rating = venue.rating {
            venueFavourite.rating = rating
        }
        venueFavourite.ratingColorString = venue.ratingColorString
        if let latitude = venue.latitude, let longitude = venue.longitude {
            venueFavourite.latitude = latitude
            venueFavourite.longitude = longitude
        }
        venueFavourite.address = venue.address
        if let distance = venue.distance {
            venueFavourite.distance = distance
        }
        if let thumbnail = venue.thumbnail {
            venueFavourite.thumbnailPrefix = thumbnail.prefix
            venueFavourite.thumbnailSuffix = thumbnail.suffix
            venueFavourite.thumbnailWidth = thumbnail.width
            venueFavourite.thumbnailHeight = thumbnail.height
        }
        return venueFavourite
    }
    
    private func setupTableView() {
        tableView.register(ImagesCollectionViewHeader.self)
        tableView.register(ViewHeaderDetail.self)
        tableView.register(TipsDetailTableViewCell.self)
        tableView.register(DefaultTableViewCell.self)
        tableView.register(MapDetailTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        addPullToRefresh()
        addInfiniteScrolling()
    }
    
    private func getShortUrl() {
        guard let id = venue?.id else { return }
        HUD.show()
        venueService.getShortUrlVenue(id: id, completion: { (urlString) in
            HUD.dismiss()
            self.shortUrl = urlString
        }) { (error) in
            HUD.dismiss()
            // WARN: show alert
            print(error?.localizedDescription ?? "")
        }
    }
    
    private func loadPhotosVenue() {
        guard let id = venue?.id else { return }
        HUD.show()
        venueService.loadPhotos(id: id, completion: { (photos) in
            HUD.dismiss()
            self.venue?.photos = photos
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }) { (error) in
            HUD.dismiss()
            // WARN: show alert
            print(error?.localizedDescription ?? "")
        }
    }
    
    private func loadTipsVenue() {
        guard let id = venue?.id else { return }
        venueService.loadTips(id: id, completion: { (tips) in
            HUD.dismiss()
            self.tips = []
            let tipsSorted = tips.sorted(by: {
                $0.createdAt > $1.createdAt
            })
            self.lastIndex = self.offset + 10 > tips.count ? tips.count : self.offset + 10
            for index in self.offset..<self.lastIndex {
                self.tips.append(tipsSorted[index])
            }
            self.tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
        }) { (error) in
            HUD.dismiss()
            // WARN: show alert
            print(error?.localizedDescription ?? "")
        }
    }
    
    private func loadmoreTipsVenue() {
        guard let id = venue?.id else { return }
        venueService.loadTips(id: id, completion: { (tips) in
            let tipsSorted = tips.sorted(by: {
                $0.createdAt > $1.createdAt
            })
            self.lastIndex = self.offset + 10 > tips.count ? tips.count : self.offset + 10
            for index in self.offset..<self.lastIndex {
                self.tips.append(tipsSorted[index])
            }
            self.tableView.reloadData()
            self.tableView.infiniteScrollingView.stopAnimating()
        }) { (error) in
            // WARN: show alert
            print(error?.localizedDescription ?? "")
            self.tableView.infiniteScrollingView.stopAnimating()
        }
    }
    
    private func addPullToRefresh() {
        tableView.addPullToRefresh {
            self.offset = 0
            self.lastIndex = 0
            self.loadTipsVenue()
            self.tableView.pullToRefreshView.stopAnimating()
            self.tableView.showsInfiniteScrolling = true
        }
    }
    
    private func addInfiniteScrolling() {
        tableView.addInfiniteScrolling {
            self.offset += 10
            if self.lastIndex < self.offset {
                self.tableView.infiniteScrollingView.stopAnimating()
                self.tableView.showsInfiniteScrolling = false
                self.tableView.reloadData()
            } else {
                self.loadmoreTipsVenue()
            }
        }
    }
    
    fileprivate func moveCommentView() {
        self.bottomViewCommentLayoutConstraint.constant = 216
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func resetCommentView() {
        self.commentTextView.endEditing(true)
        self.bottomViewCommentLayoutConstraint.constant = 0
        UIView.animate(withDuration: 0.3) { 
            self.view.layoutIfNeeded()
        }
    }
    
    private func errorMessageComment(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Action
    @IBAction private func commentAction(_ sender: Any) {
        HUD.show()
        if commentTextView.text.isEmpty {
            errorMessageComment(title: "Invalid text", message: "Text cannot be empty.")
            HUD.dismiss()
            return
        }
        if commentTextView.text.characters.count < 10 || commentTextView.text.characters.count > 200 {
            errorMessageComment(title: "Invalid text", message: "Text must be at least 10 characters and less than 200.")
            HUD.dismiss()
            return
        }
        resetCommentView()
        let userService = UserService()
        if let id = venue?.id, let textComment = commentTextView.text {
            userService.postComment(venueId: id, textComment: textComment, completion: { (_) in
                HUD.dismiss()
                self.commentTextView.text = ""
                self.errorMessageComment(title: "Success", message: "Waiting for moderators approval.")
            }, failure: { (error) in
                HUD.dismiss()
                print(error?.localizedDescription ?? "")
            })
        } else {
            HUD.dismiss()
        }
    }
}

// MARK: UITableViewDataSource
extension VenueDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let detailVenueSection = DetailVenueSection(rawValue: section) else { return 0 }
        var numberOfRowsInSection = 0
        switch detailVenueSection {
        case .PageImage:
            numberOfRowsInSection = 0
        case .Information:
            numberOfRowsInSection = 4
        case .Tips:
            numberOfRowsInSection = tips.count
        }
        return numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detailVenueSection = DetailVenueSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch detailVenueSection {
        case .PageImage:
            return UITableViewCell()
        case .Information:
            guard let infomationSection = InfomationSection(rawValue: indexPath.row) else { return UITableViewCell() }
            let cell = tableView.dequeue(DefaultTableViewCell.self)
            cell.titleLabel.text = infomationSection.title
            if let venue = venue {
                switch infomationSection {
                case .Name:
                    cell.textDetailLabel.text = venue.name
                case .Address:
                    let cellMap = tableView.dequeue(MapDetailTableViewCell.self)
                    cellMap.setupDate(string: venue.address)
                    cellMap.delegate = self
                    return cellMap
                case .Categories:
                    cell.textDetailLabel.text = venue.category
                case .Rating:
                    if let rating = venue.rating {
                        cell.textDetailLabel.text = "\(rating)"
                    }
                }
            }
            return cell
        case .Tips:
            let cell = tableView.dequeue(TipsDetailTableViewCell.self)
            cell.setupData(tip: tips[indexPath.row])
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension VenueDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let detailVenueSection = DetailVenueSection(rawValue: section) else { return 0 }
        return detailVenueSection.sectionHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let detailVenueSection = DetailVenueSection(rawValue: section) else { return nil }
        switch detailVenueSection {
        case .PageImage:
            let view = tableView.dequeue(ImagesCollectionViewHeader.self)
            if let photos = venue?.photos {
                view.photos = photos
            }
            return view
        default:
            let view = tableView.dequeue(ViewHeaderDetail.self)
            view.titleHeader.text = detailVenueSection.title
            return view
        }
    }
}

// MARK: MapDetailTableViewCellDelegate
extension VenueDetailViewController: MapDetailTableViewCellDelegate {
    
    func showMapDetailVenue() {
        let mapDirectionViewController = MapDirectionViewController()
        mapDirectionViewController.title = venue?.name
        mapDirectionViewController.venue = venue
        navigationController?.pushViewController(mapDirectionViewController, animated: true)
    }
}

// MARK: UITextViewDelegate
extension VenueDetailViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        moveCommentView()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            resetCommentView()
            return false
        }
        return true
    }
}
