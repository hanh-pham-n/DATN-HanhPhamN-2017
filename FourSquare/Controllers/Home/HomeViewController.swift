//
//  HomeViewController.swift
//  FourSquare
//
//  Created by Duy Linh on 4/2/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit
import SwiftUtils
import PageMenu

enum SectionQuery: String {
    case TopPicks = "toppicks"
    case Coffee = "coffee"
    case Food = "food"
    case Shops = "shops"
    case Trending = "trending"
    case OutDoors = "outdoors"
}

class HomeViewController: BaseViewController {
    
    // MARK: Properties
    private var pageMenu : CAPSPageMenu?
    fileprivate var itemViewControllers: [MenuItemViewController] = []
    private var topPicksViewController: TopPicksViewController = TopPicksViewController()
    private var coffeeViewController: CoffeeViewController = CoffeeViewController()
    private var foodViewController: FoodViewController = FoodViewController()
    private var shopsViewController: ShopsViewController = ShopsViewController()
    private var trendingViewController: TrendingViewController = TrendingViewController()
    private var outdoorsViewController: OutdoorsViewController = OutdoorsViewController()
    private var mapViewController: MapViewController?
    private var isShowMap = false {
        didSet {
            navigationItem.rightBarButtonItem?.image = isShowMap ? UIImage(named: "ic_list") : UIImage(named: "ic_map")
        }
    }
    fileprivate var venues: [Venue] = [] {
        didSet {
            if isShowMap {
                mapViewController?.venues = self.venues
            }
        }
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        MyLocationManager.shared.startLocation()
    }
    
    override func setupUI() {
        super.setupUI()
        navigationItem.title = "Home"
        addMapButtonItem()
        addViewController()
        configPageMenu()
    }
    
    // MARK: Private
    private func addMapButtonItem() {
        let mapButtonItem = UIBarButtonItem(image: UIImage(named: "ic_map"), style: .done, target: self, action: #selector(changeMapView))
        navigationItem.setRightBarButton(mapButtonItem, animated: true)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc private func changeMapView() {
        isShowMap = !isShowMap
        if isShowMap {
            mapViewController = MapViewController()
            if let mapViewController = self.mapViewController {
                mapViewController.venues = self.venues
                let mapViewFrame = CGRect(x: 0, y: 35 , width: kScreenSize.width, height: kScreenSize.height - 148)
                mapViewController.view.frame = mapViewFrame
                addChildViewController(mapViewController)
                view.addSubview(mapViewController.view)
            }
        } else {
            mapViewController?.view.removeFromSuperview()
            mapViewController?.removeFromParentViewController()
        }
    }
    
    private func addViewController() {
        topPicksViewController.title = Strings.MenuItemTopPicks
        coffeeViewController.title = Strings.MenuItemCoffee
        foodViewController.title = Strings.MenuItemFood
        shopsViewController.title = Strings.MenuItemShops
        trendingViewController.title = Strings.MenuItemsTrendingTitle
        outdoorsViewController.title = Strings.MenuItemsOutdoorsTitle
        itemViewControllers = [topPicksViewController, coffeeViewController, foodViewController, shopsViewController, trendingViewController, outdoorsViewController]
        for viewController in itemViewControllers {
            viewController.delegate = self
        }
    }
    
    private func configPageMenu() {
        let menuItemWidth: CGFloat = kScreenSize.width / 4
        let menuHeight: CGFloat = 35
        let parameters: [CAPSPageMenuOption] = [
            .menuHeight(menuHeight),
            .menuItemWidth(menuItemWidth),
            .menuMargin(0),
            .scrollMenuBackgroundColor(Colors.Gray235),
            .selectionIndicatorColor(Colors.Orange253),
            .selectedMenuItemLabelColor(Colors.Orange253)
        ]
        pageMenu = CAPSPageMenu(viewControllers: itemViewControllers, frame: view.bounds, pageMenuOptions: parameters)
        if let pageMenu = pageMenu {
            addChildViewController(pageMenu)
            view.addSubview(pageMenu.view)
            pageMenu.delegate = self
        }
    }
}

// MARK: CAPSPageMenuDelegate
extension HomeViewController: CAPSPageMenuDelegate {
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        let itemViewController = itemViewControllers[index]
        if !itemViewController.venues.isEmpty {
            self.venues = itemViewController.venues
        }
    }
}

// MARK: MenuItemViewDelegate
extension HomeViewController: MenuItemViewDelegate {
    
    func menuItemDidLoadData(venues: [Venue]) {
        self.venues = venues
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}
