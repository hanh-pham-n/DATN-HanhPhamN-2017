//
//  MenuItemViewController.swift
//  FourSquare
//
//  Created by Duy Linh on 5/2/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit
import SwiftUtils
import SVPullToRefresh

protocol MenuItemViewDelegate: NSObjectProtocol {
    
    func menuItemDidLoadData(venues: [Venue])
}

class MenuItemViewController: BaseViewController {
    
    // MARK: Define
    private let rowHeight: CGFloat = 143
    
    // MARK: Properties
    var venueTableView: UITableView = UITableView()
    var frameTableView: CGRect {
        return CGRect(x: 0, y: 0, width: kScreenSize.width, height: kScreenSize.height - 148)
    }
    var section: SectionQuery {
        return .TopPicks
    }
    weak var delegate: MenuItemViewDelegate?
    fileprivate var limit: Int = 10
    fileprivate var offset: Int = 0
    var isVenueEmpty = false {
        didSet {
            venueTableView.isScrollEnabled = !isVenueEmpty
        }
    }
    var venues: [Venue] = [] {
        didSet {
            isVenueEmpty = venues.isEmpty
        }
    }
    private let venueService = VenueService()
    private var isLoadmore = false
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configNotificationCenter()
    }
    
    override func setupUI() {
        super.setupUI()
        setUpTableView()
    }
    
    // MARK: Private
    private func setUpTableView() {
        venueTableView = UITableView()
        venueTableView.register(VenueItemTableViewCell.self)
        venueTableView.register(NoVenueTableViewCell.self)
        venueTableView.backgroundColor = Colors.Caramel255
        venueTableView.separatorStyle = .none
        venueTableView.showsVerticalScrollIndicator = false
        venueTableView.dataSource = self
        venueTableView.delegate = self
        venueTableView.rowHeight = rowHeight
        venueTableView.frame = frameTableView
        view.addSubview(venueTableView)
        if MyLocationManager.shared.currentLocation != nil {
            addPullToRefresh()
            addInfiniteScrolling()
        }
    }
    
    private func configNotificationCenter() {
        let notificationName = Notification.Name(rawValue: NotificationCenterKey.LoadVenue)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCurrentLocationReceive), name: notificationName, object: nil)
    }
    
    @objc private func handleCurrentLocationReceive() {
        addPullToRefresh()
        addInfiniteScrolling()
        loadVenue()
    }
    
    // MARK: Public
    func addPullToRefresh() {
        venueTableView.addPullToRefresh {
            self.offset = 0
            self.loadVenue()
            self.venueTableView.pullToRefreshView.stopAnimating()
            self.venueTableView.showsInfiniteScrolling = true
        }
    }
    
    func addInfiniteScrolling() {
        venueTableView.addInfiniteScrolling {
            self.isLoadmore = true
            if self.offset <= self.venues.count {
                self.offset += self.limit
                self.loadVenue()
            } else {
                self.venueTableView.infiniteScrollingView.stopAnimating()
                self.venueTableView.showsInfiniteScrolling = false
                self.venueTableView.reloadData()
            }
        }
    }
    
    func loadVenue() {
        if !isLoadmore {
            HUD.show()
        }
        venueService.loadVenue(section: section.rawValue, limit: limit, offset: offset, completion: { (venues) in
            if !self.isLoadmore {
                HUD.dismiss()
                self.venues = venues
                self.delegate?.menuItemDidLoadData(venues: self.venues)
                self.venueTableView.reloadData()
            } else {
                for venue in venues {
                    self.venues.append(venue)
                }
                self.delegate?.menuItemDidLoadData(venues: self.venues)
                self.venueTableView.reloadData()
                self.venueTableView.infiniteScrollingView.stopAnimating()
                self.isLoadmore = false
            }
        }) { (error) in
            HUD.dismiss()
            // WARN: show alert
            print(error?.localizedDescription ?? "")
        }
    }
}

// MARK: UITableViewDataSource
extension MenuItemViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isVenueEmpty ? 1 : venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isVenueEmpty {
            let cell = tableView.dequeue(NoVenueTableViewCell.self)
            return cell
        } else {
            let cell = tableView.dequeue(VenueItemTableViewCell.self)
            cell.setupData(venue: venues[indexPath.row])
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension MenuItemViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !venues.isEmpty {
            let venueDetailViewController = VenueDetailViewController()
            venueDetailViewController.title = venues[indexPath.row].name
            venueDetailViewController.venue = venues[indexPath.row]
            navigationController?.pushViewController(venueDetailViewController, animated: true)
        }
    }
}
