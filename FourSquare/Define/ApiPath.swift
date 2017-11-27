//
//  ApiPath.swift
//  FourSquare
//
//  Created by Duy Linh on 3/25/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import Foundation

struct ApiPath {
    
    // api foursquare
    static let baseURL = "https://api.foursquare.com/v2/venues/explore"
    static let venueDetailURL = "https://api.foursquare.com/v2/venues/"
    static let tipURL = "https://api.foursquare.com/v2/tips/add"
    static let userURL = "https://api.foursquare.com/v2/users/self"
    static let favouriteURL = "https://api.foursquare.com/v2/users/self/venuelikes"
    static let tipsSelfURL = "https://api.foursquare.com/v2/users/self/tips"
    
    // api google map
    static let gmsDirectionURL = "https://maps.googleapis.com/maps/api/directions/json"
}

/*
 
 Home                       ->  ApiPath.baseURL
 
 venue detail: get photos   ->  ApiPath.venueDetailURL
 + get tips                 ->  ApiPath.venueDetailURL + venueID + "/tips"
 
 search                     ->  ApiPath.baseURL
 
 favourite                  ->  Get id from ApiPath.favouriteURL -> load detail from ApiPath.venueDetailURL
 
 profile: get infomation    ->  ApiPath.userURL
 + get tips of me           ->  ApiPath.tipsSelfURL             *** CANCEL ***
 
 
 - add tip:                 ->  ApiPath.tipURL
 - like/dislike venue:      ->  ApiPath.venueDetailURL + venueID + "/like"
 
 */
