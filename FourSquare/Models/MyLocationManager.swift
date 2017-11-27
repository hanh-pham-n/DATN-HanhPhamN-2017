//
//  MyLocationManager.swift
//  FourSquare
//
//  Created by Duy Linh on 5/4/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit
import CoreLocation

class MyLocationManager: NSObject {
    
    // MARK: Properties
    static let shared = MyLocationManager()
    let locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var isFirstUpdate: Bool = true
    
    // MARK: Lifecycle
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = 100
    }
    
    // MARK: Public
    func startLocation() {
        locationManager.startUpdatingLocation()
    }
    
}

// MARK: CLLocationManagerDelegate
extension MyLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            currentLocation = locationManager.location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        if currentLocation != nil && isFirstUpdate {
            let notificationName = Notification.Name(rawValue: NotificationCenterKey.LoadVenue)
            NotificationCenter.default.post(name: notificationName, object: nil)
            isFirstUpdate = false
        }
        locationManager.stopUpdatingLocation()
    }
}
