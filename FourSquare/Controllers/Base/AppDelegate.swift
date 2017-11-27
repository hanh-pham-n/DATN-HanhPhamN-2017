//
//  AppDelegate.swift
//  FourSquare
//
//  Created by Duy Linh on 3/25/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit
import SwiftUtils
import GoogleMaps
import FSOAuth
import RealmSwift

typealias HUD = MainIndicatorView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL ?? "")
        } catch {
            
        }
        
        setupAPIKey()
        checkLocationService()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = configTabBar()
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == APIKeys.urlScheme {
            var errorCode: FSOAuthErrorCode = .none
            let accessCode = FSOAuth.accessCode(forFSOAuthURL: url, error: &errorCode)
            if errorCode == .none {
                let userService = UserService()
                userService.getAndSaveToken(accessCode: accessCode, completion: { (_) in
                    print("get Token Success")
                    print(Session.shared.token() ?? "")
                    let notificationName = Notification.Name(rawValue: NotificationCenterKey.Login)
                    NotificationCenter.default.post(name: notificationName, object: nil)
                }, failure: { (error) in
                    print(error?.localizedDescription ?? "")
                })
            }
        }
        return true
    }
    
    private func setupAPIKey() {
        GMSServices.provideAPIKey(GoogleMapsKeys.goolgeMapsApiKey)
    }
    
    private func configTabBar() -> TabBarController {
        let tabBarController = TabBarController()
        
        let homeVC = HomeViewController()
        let homvNavi = UINavigationController(rootViewController: homeVC)
        let searchVC = SearchViewController()
        let searchNavi = UINavigationController(rootViewController: searchVC)
        let favouriteVC = FavouriteViewController()
        let favouriteNavi = UINavigationController(rootViewController: favouriteVC)
        let profileVC = ProfileViewController()
        let profileNavi = UINavigationController(rootViewController: profileVC)
        
        homvNavi.tabBarItem = TabBarItem.init(BouncesContentView(), title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        searchNavi.tabBarItem = TabBarItem.init(BouncesContentView(), title: "Search", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        favouriteNavi.tabBarItem = TabBarItem.init(BouncesContentView(), title: "Favourite", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        profileNavi.tabBarItem = TabBarItem.init(BouncesContentView(), title: "Profile", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.viewControllers = [homvNavi, searchNavi, favouriteNavi, profileNavi]
        
        return tabBarController
    }
    
    private func checkLocationService() {
        let status = CLLocationManager.authorizationStatus()
        if status != .authorizedAlways && status != .authorizedWhenInUse {
            MyLocationManager.shared.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func showAlertLocationService() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { (_) in
            if let url = URL(string: "App-Prefs:root=Location") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        alert.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(cancelAction)
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

