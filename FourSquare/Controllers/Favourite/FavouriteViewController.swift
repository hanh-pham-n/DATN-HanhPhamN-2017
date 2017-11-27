//
//  FavouriteViewController.swift
//  FourSquare
//
//  Created by Duy Linh on 4/3/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit
import SwiftUtils

class FavouriteViewController: MenuItemViewController {
    
    // MARK: Lifecycle
    override var frameTableView: CGRect {
        return CGRect(x: 0, y: 0, width: kScreenSize.width, height: kScreenSize.height - 113)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favourite"
        isVenueEmpty = true
        setupData()
        configNotificationCenter()
    }
    
    override func addPullToRefresh() {
    }
    
    override func addInfiniteScrolling() {
    }
    
    // MARK: Private
    private func setupData() {
        let venueFavourite = RealmManager.shared.getVenueFavourite()
        for venue in venueFavourite {
            venues.append(convertToVenue(venueFavourite: venue))
        }
    }
    
    private func configNotificationCenter() {
        let notificationName = Notification.Name(rawValue: NotificationCenterKey.LoadVenueFavourite)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(_:)), name: notificationName, object: nil)
    }
    
    @objc private func reloadData(_ notification: Notification) {
        guard let venueID = notification.userInfo?["venueID"] as? String else { return }
        let venuesFavourite = RealmManager.shared.getVenueFavourite()
        var isRealm = false
        var isVenues = false
        if let _ = venues.filter({ $0.id == venueID }).first {
            isVenues = true
        }
        if let _ = venuesFavourite.filter({ $0.id == venueID }).first {
            isRealm = true
        }
        if isRealm && !isVenues {
            if let venueFavourite = venuesFavourite.filter({ $0.id == venueID }).first {
                venues.insert(convertToVenue(venueFavourite: venueFavourite), at: 0)
            }
        } else if !isRealm && isVenues {
            for index in 0..<venues.count {
                if let id = venues[index].id, id == venueID {
                    venues.remove(at: index)
                    break
                }
            }
        } else {
            return
        }
        venueTableView.reloadData()
    }
    
    private func convertToVenue(venueFavourite: VenueFavourite) -> Venue {
        let venue: Venue = Venue()
        venue.id = venueFavourite.id
        venue.name = venueFavourite.name
        venue.category = venueFavourite.category
        venue.currency = venueFavourite.currency
        venue.rating = venueFavourite.rating
        venue.ratingColorString = venueFavourite.ratingColorString
        venue.latitude = venueFavourite.latitude
        venue.longitude = venueFavourite.longitude
        venue.address = venueFavourite.address
        venue.distance = venueFavourite.distance
        venue.thumbnail = Photo(prefix: venueFavourite.thumbnailPrefix, suffix: venueFavourite.thumbnailSuffix, width: venueFavourite.thumbnailWidth, height: venueFavourite.thumbnailHeight)
        return venue
    }
}

// MARK: - UITableViewDataSource
extension FavouriteViewController {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !venues.isEmpty
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, !venues.isEmpty {
            if let id = venues[indexPath.row].id {
                RealmManager.shared.deleteVenueFavorite(id: id)
                venues.remove(at: indexPath.row)
            }
            if self.venues.count == 0 {
                self.venueTableView.reloadData()
            } else {
                self.venueTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
