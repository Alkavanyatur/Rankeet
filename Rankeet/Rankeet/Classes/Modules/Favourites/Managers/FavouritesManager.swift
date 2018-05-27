//
//  FavouritesManager.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

class FavouritesManager: NSObject {
    
    func getFacilitiesFavourites(completion:@escaping ([AlFacility]?,RankeetError?)->Void){
        FavouritesDataProvider.sharedInstance.getFavouritesFacilities { (facilities, error) in
            completion(facilities,error)
        }
    }
    
    func isFacilityFavourite(currentFacility:AlFacility)->Bool{
         return FavouritesDataProvider.sharedInstance.isFacilityFavourite(currentFacility: currentFacility)
    }
    
    func addFacilityFavourite(currentFacility:AlFacility){
        return FavouritesDataProvider.sharedInstance.addFacilityFavourite(currentFacility:currentFacility)
    }
    
    func removeFacilityFavourite(currentFacility:AlFacility){
        return FavouritesDataProvider.sharedInstance.removeFacilityFavourite(currentFacility:currentFacility)
    }
}
