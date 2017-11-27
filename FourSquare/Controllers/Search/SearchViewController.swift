//
//  SearchViewController.swift
//  FourSquare
//
//  Created by Duy Linh on 4/3/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit
import SwiftUtils

class SearchViewController: BaseViewController {
    
    // MARK: Define
    private let radius: CGFloat = 6.0
    
    // MARK: Properties
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet fileprivate weak var nameTextField: UITextField!
    @IBOutlet fileprivate weak var cityTextField: UITextField!
    private var searchMapViewController: MapViewController?
    private var searchListViewController: SearchListViewController?
    private var isInit = false {
        didSet {
            if isInit && !isShowMap {
                addSearchListView()
            }
        }
    }
    private var isShowMap = false {
        didSet {
            navigationItem.rightBarButtonItem?.image = isShowMap ? UIImage(named: "ic_list") : UIImage(named: "ic_map")
        }
    }
    private var venues: [Venue] = [] {
        didSet {
            if self.isShowMap {
                self.searchMapViewController?.venues = venues
            } else {
                self.searchListViewController?.venues = venues
                self.searchListViewController?.venueTableView.reloadData()
            }
        }
    }
    
    // MARK: Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        navigationItem.title = "Search"
        searchButton.layer.cornerRadius = radius
        searchButton.isEnabled = false
        addMapButtonItem()
        nameTextField.delegate = self
        cityTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textDidChange(textField:)), for: .editingChanged)
        cityTextField.addTarget(self, action: #selector(textDidChange(textField:)), for: .editingChanged)
    }
    
    // MARK: Private
    @objc private func endOfEdit() {
        self.view.endEditing(true)
    }
    
    @objc private func textDidChange(textField: UITextField) {
        let textFields: [UITextField] = [nameTextField, cityTextField]
        var isOK = true
        for textField in textFields {
            if textField.text == "" {
                isOK = false
                break
            }
        }
        searchButton.isEnabled = isOK
        searchButton.backgroundColor = isOK ? Colors.Orange253 : Colors.Gray155
    }
    
    private func addMapButtonItem() {
        let mapButtonItem = UIBarButtonItem(image: UIImage(named: "ic_map"), style: .done, target: self, action: #selector(changeMapView))
        navigationItem.setRightBarButton(mapButtonItem, animated: true)
    }
    
    private func addSearchListView() {
        searchListViewController = SearchListViewController()
        if let searchListViewController = self.searchListViewController {
            addChildViewController(searchListViewController)
            contentView.addSubview(searchListViewController.view)
            searchListViewController.venues = self.venues
            searchListViewController.venueTableView.reloadData()
        }
    }
    
    private func addSearchMapView() {
        searchMapViewController = SearchMapViewController()
        if let searchMapViewController = self.searchMapViewController {
            addChildViewController(searchMapViewController)
            contentView.addSubview(searchMapViewController.view)
            searchMapViewController.venues = self.venues
            searchMapViewController.backButton.isHidden = true
            searchMapViewController.nextButton.isHidden = venues.count < 2
            let mapViewFrame = contentView.bounds
            searchMapViewController.view.frame = mapViewFrame
        }
    }
    
    @objc private func changeMapView() {
        isShowMap = !isShowMap
        if isShowMap {
            searchListViewController?.view.removeFromSuperview()
            searchListViewController?.removeFromParentViewController()
            addSearchMapView()
        } else {
            searchMapViewController?.view.removeFromSuperview()
            searchMapViewController?.removeFromParentViewController()
            if self.isInit {
                addSearchListView()
            }
        }
    }
    
    // MARK: Action
    @IBAction private func searchAction(_ sender: Any) {
        if let near = cityTextField.text, let query = nameTextField.text {
            HUD.show()
            view.endEditing(true)
            let venueService = VenueService()
            venueService.searchVenue(near: near, query: query, completion: { (venues) in
                HUD.dismiss()
                if !self.isInit {
                    self.isInit = true
                }
                self.venues = venues
            }) { (error) in
                HUD.dismiss()
                print(error?.localizedDescription ?? "")
            }
        }
    }
}

// MARK: UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
