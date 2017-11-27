//
//  GMSDirectionService.swift
//  FourSquare
//
//  Created by Duy Linh on 5/11/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import Foundation
import GoogleMaps
import Alamofire

typealias GoogleCompletion = (String) -> Void

class GoogleDirectionService {
    
    func addOverlayToMapView(currentLocationCoord: CLLocationCoordinate2D, venueLocationCoord: CLLocationCoordinate2D, completion: GoogleCompletion?) {
        let path = ApiPath.gmsDirectionURL
        var params: Parameters = Parameters()
        params["origin"] = "\(currentLocationCoord.latitude), \(currentLocationCoord.longitude)"
        params["destination"] = "\(venueLocationCoord.latitude), \(venueLocationCoord.longitude)"
        params["key"] = GoogleMapsKeys.goolgeMapsApiKey
        
        Alamofire.request(path, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            switch response.result {
            case .success(let data):
                var json: Any?
                json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                if let jsonData = json as? JSObject, let routes = jsonData["routes"] as? JSArray {
                    if !routes.isEmpty {
                        if let overViewPolyline = routes.first?["overview_polyline"] as? JSObject, let points = overViewPolyline["points"] as? String {
                            completion?(points)
                            return
                        }
                    }
                }
                completion?("")
            case .failure(_):
                completion?("")
            }
        }
    }
    
}
