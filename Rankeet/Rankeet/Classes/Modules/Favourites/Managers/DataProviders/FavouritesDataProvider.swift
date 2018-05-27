//
//  BookingsDataProvider.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class FavouritesDataProvider: NSObject {
    static let sharedInstance = FavouritesDataProvider()
    
    func isFacilityFavourite(currentFacility:AlFacility)->Bool{
        let realm = try! Realm()
        
        let facilities = realm.objects(AlFacilityStored.self).filter("idFacility == '\(currentFacility.idFacility)'")
        if facilities.count > 0 {
            return true
        }
        return false
    }
    
    func addFacilityFavourite(currentFacility:AlFacility){
        let realm = try! Realm()
        
        let currentFacilityStored = AlFacilityStored()
        currentFacilityStored.idFacility = currentFacility.idFacility
        currentFacilityStored.currentDate = Date()
        currentFacilityStored.facility = currentFacility
        
        try! realm.write {
            realm.add(currentFacilityStored)
        }
    }
    
    func removeFacilityFavourite(currentFacility:AlFacility){
        let realm = try! Realm()
         let facilities = realm.objects(AlFacilityStored.self).filter("idFacility == '\(currentFacility.idFacility)'")
        try! realm.write {
            realm.delete(facilities)
        }
    }
    
    func getFavouritesFacilities(completion:@escaping ([AlFacility]?,RankeetError?)->Void){
        var facilities:[AlFacility] = []
        let realm = try! Realm()
        let currentFacilitiesStored = realm.objects(AlFacilityStored.self)
        for facilityStored in currentFacilitiesStored{
            if let facilit = facilityStored.facility{
                facilities.append(facilit)
            }
        }
        completion(facilities,nil)
    }
}
