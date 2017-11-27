//
//  MapDirectionViewController.swift
//  FourSquare
//
//  Created by Duy Linh on 5/5/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit
import GoogleMaps

class MapDirectionViewController: BaseViewController {

    // MARK: Define
    private var zoomLevel: Float = 15.0
    private let insets =  UIEdgeInsets(top: 30, left: 30, bottom: 150, right: 30)
    
    // MARK: Properties
    @IBOutlet private weak var mapView: GMSMapView!
    var venue: Venue?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        setUpMyLocationManager()
        addMarker()
        drawRouteGoogleMaps()
    }
    
    // MARK: Private
    private func setUpMyLocationManager() {
        self.mapView.isMyLocationEnabled = true
    }
    
    private func addMarker() {
        if let venue = self.venue, let latitude = self.venue?.latitude, let longitude = self.venue?.longitude {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            marker.title = venue.name
            marker.icon = GMSMarker.markerImage(with: UIColor.red)
            marker.map = mapView
            mapView.camera = GMSCameraPosition(target: marker.position, zoom: zoomLevel, bearing: 0, viewingAngle: 0)
            mapView.selectedMarker = marker
            let path = GMSMutablePath()
            path.add(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        }
    }
    
    private func drawRouteGoogleMaps() {
        guard let currentLocation = MyLocationManager.shared.currentLocation else { return }
        let currentLocationCoord = currentLocation.coordinate
        guard let latitude = self.venue?.latitude, let longitude = self.venue?.longitude else { return }
        let venueLocationCoord = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        GoogleDirectionService().addOverlayToMapView(currentLocationCoord: currentLocationCoord, venueLocationCoord: venueLocationCoord) { (encodedString) in
            self.addPolyLineWithEncodedString(encodedString: encodedString)
        }
    }
    
    private func addPolyLineWithEncodedString(encodedString: String) {
        guard let path = GMSMutablePath(fromEncodedPath: encodedString) else { return }
        let polyLine = GMSPolyline(path: path)
        polyLine.strokeWidth = 3.0
        polyLine.strokeColor = Colors.Orange253
        polyLine.map = mapView
        let bounds = GMSCoordinateBounds(path: path)
        mapView.animate(with: GMSCameraUpdate.fit(bounds, with: insets))
    }
    
    // Action:
    @IBAction private func currentLocationAction(_ sender: Any) {
        if let coordinate = MyLocationManager.shared.currentLocation?.coordinate {
            let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: zoomLevel)
            mapView.camera = camera
        }
    }
}
