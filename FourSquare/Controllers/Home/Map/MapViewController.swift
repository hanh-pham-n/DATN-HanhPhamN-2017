//
//  MapViewController.swift
//  FourSquare
//
//  Created by Duy Linh on 5/4/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: BaseViewController {

    // MARK: Define
    private var zoomLevel: Float = 15.0
    
    // MARK: Properties
    @IBOutlet private weak var mapView: GMSMapView!
    @IBOutlet public weak var venueCollectionView: UICollectionView!
    @IBOutlet public weak var backButton: UIButton!
    @IBOutlet public weak var nextButton: UIButton!
    private var isInit = false
    fileprivate var markers: [GMSMarker] = []
    fileprivate var selectedMarker: GMSMarker? {
        didSet {
            if selectedMarker != oldValue {
                oldValue?.icon = GMSMarker.markerImage(with: UIColor.red)
                selectedMarker?.icon = GMSMarker.markerImage(with: UIColor.green)
                mapView.selectedMarker = selectedMarker
                if let selectedMarker = selectedMarker {
                    let camera = GMSCameraPosition.camera(withLatitude: selectedMarker.position.latitude, longitude: selectedMarker.position.longitude, zoom: zoomLevel)
                    mapView.camera = camera
                }
            } else {
                mapView.selectedMarker = selectedMarker
            }
        }
    }
    var venues: [Venue] = [] {
        didSet {
            if !oldValue.isEmpty {
                clearMapData()
                addMarker()
                venueCollectionView.reloadData()
                scrollToCellAtIndex(index: 0, animated: false)
                configureChangeCellButton(index: 0)
            } else if isInit {
                addMarker()
                venueCollectionView.reloadData()
                scrollToCellAtIndex(index: 0, animated: false)
                configureChangeCellButton(index: 0)
            }
        }
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        isInit = true
    }
    
    override func setupUI() {
        super.setupUI()
        configCollectionView()
        configMapView()
        backButton.isHidden = true
        nextButton.isHidden = venues.count == 1
    }
    
    // MARK: Private
    private func configCollectionView() {
        venueCollectionView.register(VenueCollectionViewCell.self)
        venueCollectionView.backgroundColor = UIColor.clear
        venueCollectionView.dataSource = self
        venueCollectionView.delegate = self
    }
    
    private func configMapView() {
        mapView.delegate = self
        if let currentLocation = MyLocationManager.shared.currentLocation {
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,
                                                  longitude: currentLocation.coordinate.longitude,
                                                  zoom: zoomLevel)
            mapView.camera = camera
            mapView.isMyLocationEnabled = true
        }
        addMarker()
    }
    
    private func clearMapData() {
        mapView.clear()
        markers = []
    }
    
    private func addMarker() {
        for venue in venues {
            if let latitude = venue.latitude, let longitude = venue.longitude {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                marker.title = venue.name
                marker.icon = GMSMarker.markerImage(with: UIColor.red)
                marker.map = mapView
                markers.append(marker)
            }
        }
        if !markers.isEmpty {
            let camera = GMSCameraPosition.camera(withLatitude: markers[0].position.latitude,
                                                  longitude: markers[0].position.longitude,
                                                  zoom: zoomLevel)
            mapView.camera = camera
            mapView.selectedMarker = markers[0]
            selectedMarker = markers[0]
        }
    }
    
    fileprivate func configureChangeCellButton(index: Int) {
        backButton.isHidden = index == 0
        if venues.count < 2 || index == venues.count - 1 {
            nextButton.isHidden = true
        } else {
            nextButton.isHidden = false
        }
    }
    
    fileprivate func scrollToCellAtIndex(index: Int, animated: Bool) {
        if venues.isEmpty {
            venueCollectionView.isHidden = true
        } else {
            venueCollectionView.isHidden = false
            let indexPath: IndexPath = IndexPath(row: index, section: 0)
            venueCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
            selectedMarker = markers[index]
            configureChangeCellButton(index: index)
        }
    }
    
    fileprivate func indexCollection() -> Int {
        let contentOffsetX = venueCollectionView.contentOffset.x
        let contentWidth = venueCollectionView.bounds.width
        let index = Int(contentOffsetX / contentWidth)
        return index
    }
    
    private func setSelectedMarker(newIndex: Int) {
        let camera = GMSCameraPosition.camera(withLatitude: markers[newIndex].position.latitude,
                                              longitude: markers[newIndex].position.longitude,
                                              zoom: zoomLevel)
        mapView.camera = camera
        mapView.selectedMarker = markers[newIndex]
        selectedMarker = markers[newIndex]
    }
    
    // MARK: Action
    @IBAction private func backCollectionCellAction(_ sender: Any) {
        let index = indexCollection() - 1
        if index < 0 {
            return
        } else {
            scrollToCellAtIndex(index: index, animated: true)
        }
        venueCollectionView.allowsSelection = false
    }
    
    @IBAction private func nextCollectionCellAction(_ sender: Any) {
        let index = indexCollection() + 1
        if index >= venues.count {
            return
        } else {
            scrollToCellAtIndex(index: index, animated: true)
        }
        venueCollectionView.allowsSelection = false
    }
}

// MARK: - UIScrollViewDelegate
extension MapViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        configureChangeCellButton(index: indexCollection())
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        selectedMarker = markers[indexCollection()]
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        venueCollectionView.allowsSelection = true
    }
}

// MARK: UICollectionViewDataSource
extension MapViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return venues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(VenueCollectionViewCell.self, forIndexPath: indexPath)
        cell.setupData(venue: venues[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension MapViewController: UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return venueCollectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let venueDetailViewController = VenueDetailViewController()
        venueDetailViewController.title = venues[indexPath.row].name
        venueDetailViewController.venue = venues[indexPath.row]
        navigationController?.pushViewController(venueDetailViewController, animated: true)
    }
}

// MARK: GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let indexRow = self.markers.index(of: marker) {
            scrollToCellAtIndex(index: indexRow, animated: true)
        }
        return true
    }
}
