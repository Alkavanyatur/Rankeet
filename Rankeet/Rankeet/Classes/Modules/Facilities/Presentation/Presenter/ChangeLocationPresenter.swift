//
//  ChangeLocationPresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 23/2/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import GooglePlaces

protocol ChangeLocationPresenterDelegate: NSObjectProtocol {
    func showLoadingLocation()
    func hideLoadingLocation(completionLoading:@escaping (Bool?) -> Void)
    func showMessageNoPlaceInfoError()
    func loadFacilities(facilities:[AlFacility])
}

class ChangeLocationPresenter: NSObject {
    private weak var delegate: ChangeLocationPresenterDelegate?
    private var locationManager : LocationManager!
    private var facilitiesManager : FacilitiesManager!
    private var currentStoredLocations : [UserPlace]?
    
    init(delegate: ChangeLocationPresenterDelegate) {
        self.delegate = delegate
        self.locationManager = LocationManager()
        self.facilitiesManager = FacilitiesManager()
        self.currentStoredLocations = self.locationManager.requestPlacesStored()
    }
    
    //
    // MARK: - Public methods
    //
    
    func closeLocationScreen(){
        self.transitionToPrevScreen(currentPlace: nil)
    }
    
    func requestPlacesFetcherConfiguration(controller:GMSAutocompleteFetcherDelegate){
        self.locationManager.configurePlacesFetcherWithController(controller: controller)
    }
    
    func promoteChangeInSearchText(searchText:String?){
        if let currentString = searchText{
            self.locationManager.changeInSearchplacesFetcher(search: currentString+" "+RankeetDefines.Location.defaultNameLocation)
            self.facilitiesManager.getListFacilitiesWithText(currentText: currentString, completion: { (facilities, error) in
                if let currentFacilities = facilities?.objects{
                    self.delegate?.loadFacilities(facilities: currentFacilities)
                }
            })
        }
    }
    
    func requestLocationDetail(currentPlaceId:String){
        self.delegate?.showLoadingLocation()
        self.locationManager.requestLocationDetail(currentPlaceId: currentPlaceId) { (place,error) in
            self.delegate?.hideLoadingLocation(completionLoading: { (finish) in
                guard error == nil else{
                    self.delegate?.showMessageNoPlaceInfoError()
                    return
                }
                if let currentPlace = place {
                    self.transitionToPrevScreen(currentPlace:currentPlace)
                }
            })
        }
    }
    
    func requestNumPlacesStored()->Int{
        return self.currentStoredLocations?.count ?? 0
    }
    
    func requestPlacesStored(currentIndex:Int)->UserPlace?{
        return self.currentStoredLocations?[currentIndex]
    }
    
    func requestPlacesStoredCount()->Int{
        if let currentStoredLocationsCount = self.currentStoredLocations?.count {
            return currentStoredLocationsCount
        }else{
            return 0
        }
    }
    
    func requestAccesToDetail(currentFacility:AlFacility){
        self.transitionToPrevScreen(currentFacility: currentFacility)
    }
    
    func requestUseLocationUser(){
        self.delegate?.showLoadingLocation()
        self.locationManager.requestLocation { (enabled) in
            if (enabled){
                self.locationManager.requestLocationUpdate(completion: { (long, lat) in
                    self.locationManager.requestPlaceFromUserLocation(userLat: lat, userLong: long, completion: { (user, error) in
                        self.delegate?.hideLoadingLocation(completionLoading: { (complete) in
                            if let currentPlace = user {
                                self.transitionToPrevScreen(currentPlace:currentPlace)
                            }
                        })
                    })
                })
            }else{
                self.delegate?.hideLoadingLocation(completionLoading: { (complete) in
                    self.delegate?.showMessageNoPlaceInfoError()
                })
            }
        }
    }
}

//
// MARK: - Transition Methods
//

extension ChangeLocationPresenter{
    func transitionToPrevScreen(currentPlace:UserPlace?){
        RouterManager.shared.visibleViewController?.dismiss(animated: true, completion: {
            if let place = currentPlace, let mainStructureController = RouterManager.shared.visibleViewController as? MainStructureViewController, let facilitiesViewController = (mainStructureController.selectedViewController as? UINavigationController)?.visibleViewController as? FacilitiesViewController  {
                facilitiesViewController.configureWithPlace(currentPlace: place, needAnimation: true, currentState: .correctResponse)
            }
        })
    }
    
    func transitionToPrevScreen(currentFacility:AlFacility?){
        RouterManager.shared.visibleViewController?.dismiss(animated: true, completion: {
            if let currentFacility = currentFacility, let mainStructureController = RouterManager.shared.visibleViewController as? MainStructureViewController, let facilitiesViewController = (mainStructureController.selectedViewController as? UINavigationController)?.visibleViewController as? FacilitiesViewController  {
                facilitiesViewController.configureWithFacility(currentFacility: currentFacility, needAnimation: true)
            }
        })
    }
}
