//
//  LocationManager.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/2/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationManager: NSObject {

}

//
// MARK: - Request location methods
//
extension LocationManager {
    func requestLocation(completion:@escaping (Bool) -> Void){
        LocationDataProvider.sharedInstance.enableLocationServices { (enabled) in
            completion(enabled)
        }
    }
    func needToRequestLocation()-> Bool{
        return LocationDataProvider.sharedInstance.needToRequestLocationPermission()
    }
    func isLocationEnabled()-> Bool{
        return LocationDataProvider.sharedInstance.isLocationPermissionEnabled()
    }
    
    func requestLocationUpdate(completion:@escaping (Double,Double) -> Void){
        LocationDataProvider.sharedInstance.startUpdatingLocations { (long, lat) in
            completion(long,lat)
        }
    }
}


//
// MARK: - Places methods
//

extension LocationManager {
    
    func getDefaultUserPlace()->UserPlace{
        let defaultUserPlace = UserPlace()
        defaultUserPlace.address = RankeetDefines.Location.defaultNameLocation
        defaultUserPlace.latCoordinate = RankeetDefines.Location.defaultLat
        defaultUserPlace.longCoordinate = RankeetDefines.Location.defaultLong
        return defaultUserPlace
    }
    
    func configurePlacesFetcherWithController(controller:GMSAutocompleteFetcherDelegate){
        LocationDataProvider.sharedInstance.configurePlacesFetcherWithController(controller:controller)
    }
    
    func changeInSearchplacesFetcher(search:String?){
        LocationDataProvider.sharedInstance.changeInSearchplacesFetcher(search: search)
    }
    
    func requestLocationDetail(currentPlaceId:String,completion:@escaping (UserPlace?,RankeetError?)->Void){
        LocationDataProvider.sharedInstance.requestPlaceDetailWithId(currentPlaceId: currentPlaceId) { (place,error) in
            completion(place,error)
        }
    }
    func requestPlacesStored()->[UserPlace]?{
        return LocationDataProvider.sharedInstance.requestPlacesStored()
    }
    
    func requestCurrentPlace()->UserPlace?{
        return LocationDataProvider.sharedInstance.requestCurrentPlace()
    }
    
    func requestPlaceFromUserLocation(userLat:Double,userLong:Double,completion:@escaping (UserPlace?,RankeetError?)->Void){
        LocationDataProvider.sharedInstance.requestPlaceFromUserLocation(latUser: userLat, longUser: userLong) { (user, error) in
            completion(user,error)
        }
    }
}





