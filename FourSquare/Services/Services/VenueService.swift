//
//  VenueService.swift
//  FourSquare
//
//  Created by Duy Linh on 5/7/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class VenueService {
    
    typealias VenueServiceSuccess = ([Venue]) -> Void
    typealias PhotosServiceSuccess = ([Photo]) -> Void
    typealias TipsServiceSuccess = ([Tip]) -> Void
    typealias ShortUrlServiceSuccess = (String) -> Void
    
    func loadVenue(section: String, limit: Int, offset: Int, completion: VenueServiceSuccess?, failure: Failure? = nil) {
        var params: Parameters = Parameters()
        guard let currentLocation = MyLocationManager.shared.currentLocation else {
            failure?(NSError.locationService())
            return
        }
        params["ll"] = "\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)"
        params["section"] = section
        params["limit"] = limit
        params["offset"] = offset
        params["venuePhotos"] = 1
        api.get(path: ApiPath.baseURL, parameters: params, success: { (response) in
            var venues: [Venue] = []
            if let groups = response?["groups"] as? JSArray {
                for group in groups {
                    if let items = group["items"] as? JSArray {
                        for item in items {
                            if let venueObject = item["venue"] as? JSObject {
                                if let venue = Mapper<Venue>().map(JSON: venueObject) {
                                    venues.append(venue)
                                }
                            }
                        }
                    }
                }
            }
            completion?(venues)
        }) { (error) in
            failure?(error)
        }
    }
    
    func loadPhotos(id: String, completion: PhotosServiceSuccess?, failure: Failure? = nil) {
        let path = ApiPath.venueDetailURL + id
        api.get(path: path, parameters: nil, success: { (result) in
            var photosArray: [Photo] = []
            if let venue = result?["venue"] as? JSObject {
                if let photos = venue["photos"] as? JSObject {
                    if let count = photos["count"] as? Int {
                        if count > 0 {
                            if let groups = photos["groups"] as? JSArray {
                                if let items = groups[0]["items"] as? JSArray {
                                    for item in items {
                                        if let photo = Mapper<Photo>().map(JSON: item) {
                                            photosArray.append(photo)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            completion?(photosArray)
        }) { (error) in
            failure?(error)
        }
    }
    
    func loadTips(id: String, completion: TipsServiceSuccess?, failure: Failure? = nil) {
        var params: Parameters = Parameters()
        params["sort"] = "recent"
        params["offset"] = 0
        params["limit"] = 400
        let path = ApiPath.venueDetailURL + id + "/tips"
        api.get(path: path, parameters: params, success: { (result) in
            var tipsArray: [Tip] = []
            if let tips = result?["tips"] as? JSObject {
                if let items = tips["items"] as? JSArray {
                    for item in items {
                        if let tip = Mapper<Tip>().map(JSON: item) {
                            tipsArray.append(tip)
                        }
                    }
                }
            }
            completion?(tipsArray)
        }) { (error) in
            failure?(error)
        }
    }
    
    func searchVenue(near: String, query: String, completion: VenueServiceSuccess?, failure: Failure? = nil) {
        var params: Parameters = Parameters()
        guard let currentLocation = MyLocationManager.shared.currentLocation else {
            failure?(NSError.locationService())
            return
        }
        params["ll"] = "\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)"
        params["near"] = near
        params["query"] = query
        params["venuePhotos"] = 1
        api.get(path: ApiPath.baseURL, parameters: params, success: { (response) in
            var venues: [Venue] = []
            if let groups = response?["groups"] as? JSArray {
                for group in groups {
                    if let items = group["items"] as? JSArray {
                        for item in items {
                            if let venueObject = item["venue"] as? JSObject {
                                if let venue = Mapper<Venue>().map(JSON: venueObject) {
                                    venues.append(venue)
                                }
                            }
                        }
                    }
                }
            }
            completion?(venues)
        }) { (error) in
            failure?(error)
        }
    }
    
    func getShortUrlVenue(id: String, completion: ShortUrlServiceSuccess?, failure: Failure? = nil) {
        let path = ApiPath.venueDetailURL + id
        api.get(path: path, parameters: nil, success: { (response) in
            var urlString = ""
            if let venue = response?["venue"] as? JSObject {
                if let shortUrl = venue["shortUrl"] as? String {
                    urlString = shortUrl
                }
            }
            completion?(urlString)
        }) { (error) in
            failure?(error)
        }
    }
}
