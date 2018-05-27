//
//  LocationDataProvider.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import RealmSwift

class LocationDataProvider: NSObject {
    
    let locationManager :CLLocationManager!
    var completionLocation: ((Bool)->Void)?
    var updateLocation: ((Double,Double)->Void)?
    var fetcher: GMSAutocompleteFetcher?
    var placesClient : GMSPlacesClient?
    var cLGeocoder :CLGeocoder!
    
    var currentUserPlace : UserPlace?
    
    static let sharedInstance = LocationDataProvider()

    override init() {
        self.locationManager = CLLocationManager()
        self.placesClient = GMSPlacesClient()
        self.cLGeocoder = CLGeocoder()
        super.init()
    }
    
    //
    // MARK: - Permissions methods
    //
    
    func enableLocationServices(completion:@escaping (Bool)->Void){
        self.completionLocation = completion
        self.locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            self.locationPermissionRequested()
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
            responseWithNoLocationFeatures()
            break
        case .authorizedWhenInUse:
            responseWithLocationFeatures()
            break
        case .authorizedAlways:
            responseWithLocationFeatures()
            break
        }
    }
    
    func responseWithNoLocationFeatures(){
        if self.completionLocation != nil {
            self.completionLocation!(false)
        }
    }
    
    func responseWithLocationFeatures(){
        if self.completionLocation != nil {
            self.completionLocation!(true)
        }
    }
    
    func isLocationPermissionEnabled()->Bool{
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            return false
        case .restricted, .denied:
            return false
        case .authorizedWhenInUse:
            return true
        case .authorizedAlways:
            return true
        }
    }
    
    func locationPermissionRequested(){
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: RankeetDefines.Location.location_requested)
        defaults.synchronize()
    }
    
    func needToRequestLocationPermission()->Bool{
        let defaults = UserDefaults.standard
        defaults.synchronize()
        guard defaults.object(forKey: RankeetDefines.Location.location_requested) == nil else {
            return false
        }
        return true
    }
    
    //
    // MARK: - Location methods
    //
    
    func startUpdatingLocations(completion:@escaping (Double,Double)->Void){
        self.updateLocation = completion
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }
    
    //
    // MARK: - Places methods
    //
    
    func configurePlacesFetcherWithController(controller:GMSAutocompleteFetcherDelegate){
        // Set bounds to inner-west Sydney Australia.
        let neBoundsCorner = CLLocationCoordinate2D(latitude: 40.546299,
                                                    longitude: 3.538995)
        let swBoundsCorner = CLLocationCoordinate2D(latitude: 40.302714,
                                                    longitude: 3.871332)
        let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner,
                                         coordinate: swBoundsCorner)
        
        // Set up the autocomplete filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        
        // Create the fetcher.
        self.fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
        self.fetcher?.delegate = controller
    }
    
    func changeInSearchplacesFetcher(search:String?){
        self.fetcher?.sourceTextHasChanged(search)
    }
    
    func requestPlaceDetailWithId(currentPlaceId:String,completion:@escaping (UserPlace?,RankeetError?)->Void){
        self.placesClient?.lookUpPlaceID(currentPlaceId, callback: { (place, error) in
            if error != nil {
                completion(nil,RankeetError.unknown)
                return
            }
            guard let place = place else {
                completion(nil,RankeetError.noPlaceInfo)
                return
            }
            let currentUserPlace = UserPlace(value: ["idGoogle" : place.placeID, "address": place.formattedAddress ?? "", "timestamp":NSDate().timeIntervalSince1970, "latCoordinate":place.coordinate.latitude,"longCoordinate":place.coordinate.longitude])
            
            let realm = try! Realm()
            try! realm.write {
                realm.add(currentUserPlace, update: true)
            }
            completion(currentUserPlace, nil)
        })
    }
    
    func requestPlacesStored()->[UserPlace]?{
        let realm = try! Realm()
        let currentPlaces = Array(realm.objects(UserPlace.self).sorted(byKeyPath: "timestamp", ascending: false))
        var places:[UserPlace]? = []
        for i in 0..<5 {
            if currentPlaces.count > i {
                places?.append(currentPlaces[i])
            }
        }
        return places
    }
    
    func requestCurrentPlace()->UserPlace?{
        return self.currentUserPlace
    }

    func requestPlaceFromUserLocation(latUser:Double,longUser:Double,completion:@escaping (UserPlace?,RankeetError?)->Void){
        let location = CLLocation(latitude: latUser, longitude: longUser)
        self.cLGeocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                completion(nil,RankeetError.noPlaceInfo)
            } else {
                if let placemarks = placemarks, let placemark = placemarks.first {
                    let currentUserPlace = UserPlace(value: ["idGoogle" : "", "address": placemark.compactAddress ?? "", "timestamp":NSDate().timeIntervalSince1970, "latCoordinate":placemark.location?.coordinate.latitude ?? 0.0,"longCoordinate":placemark.location?.coordinate.longitude ?? 0.0])
                    self.currentUserPlace = currentUserPlace
                    completion(currentUserPlace,nil)
                } else {
                    completion(nil,RankeetError.noPlaceInfo)
                }
            }
        }
    }
}


extension LocationDataProvider: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {   switch status {
    case .restricted, .denied:
        responseWithNoLocationFeatures()
        break
    case .authorizedWhenInUse:
        responseWithLocationFeatures()
        break
    case .authorizedAlways:
        responseWithLocationFeatures()
        break
    case .notDetermined:
        break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        self.locationManager.stopUpdatingLocation()
        self.updateLocation?(Double(long),Double(lat))
    }
}
