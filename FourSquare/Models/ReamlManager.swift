//
//  ReamlManager.swift
//  FourSquare
//
//  Created by Duy Linh on 5/11/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    
    func addVenueFavourite(venueFavourite: VenueFavourite) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(venueFavourite)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func deleteVenueFavorite(id: String) {
        do {
            let realm = try Realm()
            try realm.write {
                if let venue = realm.objects(VenueFavourite.self).filter("id = '\(id)'").first {
                    realm.delete(venue)
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    func getVenueFavourite() -> Results<VenueFavourite> {
        var result: Results<VenueFavourite>!
        do {
            let realm = try Realm()
            result = realm.objects(VenueFavourite.self).sorted(byKeyPath: "favoriteTimestamp", ascending: false)
        } catch let error {
            print(error.localizedDescription)
        }
        return result
    }
    
    func isFavourite(id: String) -> Bool {
        do {
            let realm = try Realm()
            if let _ = realm.objects(VenueFavourite.self).filter("id = '\(id)'").first {
                return true
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return false
    }
}
