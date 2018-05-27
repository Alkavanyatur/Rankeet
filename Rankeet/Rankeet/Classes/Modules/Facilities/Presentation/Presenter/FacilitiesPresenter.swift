//
//  FacilitiesPresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18..
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import MapKit

protocol FacilitiesPresenterDelegate: NSObjectProtocol {
    
    func requestPermissionLocation()
    func responseWithNoLocationEnabled(show:Bool)
    func configureWithPlace(currentPlace:UserPlace, needAnimation:Bool, currentState:RankeetLocationResponseType)
    func configureWithPlaceFromMap(currentPlace:UserPlace)
    
    func showLoadingFacilities()
    func hideLoadingFacilities(completionLoading:@escaping (Bool?) -> Void)
    func showMessageNoFacilitiesInfoError()
    
    func loadFacilities(facilities:[AlFacility])
    
    func showMapMode()
    func hideMapMode()
    
    func configureMapButton()
    func configureListButton()
}

enum RankeetLocationResponseType {
    case errorRetrieve
    case farAwayFromCenter
    case noLocation
    case correctResponse
}

class FacilitiesPresenter: NSObject {
    
    private weak var delegate: FacilitiesPresenterDelegate?
    private var facilitiesManager : FacilitiesManager!
    private var onboardingManager : OnboardingManager!
    private var locationManager : LocationManager!
    
    private var checkingLocationFromSettings : Bool = false
    
    init(delegate: FacilitiesPresenterDelegate) {
        self.delegate = delegate
        self.facilitiesManager = FacilitiesManager()
        self.onboardingManager = OnboardingManager()
        self.locationManager = LocationManager()
    }
    
    //
    // MARK: - configuration methods
    //
    func viewDidAppear(){
        self.delegate?.showLoadingFacilities()
        self.manageLocationState()
    }
    
    func selectFacilityDetail(currentFacility:AlFacility, currentPlace:UserPlace, needTransition:Bool){
        self.transitionToFacilityDetail(currentFacility:currentFacility,currentPlace:currentPlace,needTransition: needTransition)
    }
    
    //
    // MARK: - locations methods
    //
    func manageLocationState(){
        if self.locationManager.needToRequestLocation(){
            self.delegate?.requestPermissionLocation()
        }else{
            if self.locationManager.isLocationEnabled(){
                self.requestUpdateLocation()
            }else{
                self.noLocationResponse()
            }
        }
    }
    
    func requestLocation(){
        self.locationManager.requestLocation { (enabled) in
            if (enabled){
                self.requestUpdateLocation()
            }else{
                self.noLocationResponse()
            }
        }
    }
    
    func noLocationResponse(){
        self.responseNotLocationEnabled()
        self.delegate?.configureWithPlace(currentPlace: self.locationManager.getDefaultUserPlace(), needAnimation: false, currentState: .noLocation)
    }
    
    func checkBackFromSettings(){
        if self.checkingLocationFromSettings {
            self.checkingLocationFromSettings = false
            if self.locationManager.isLocationEnabled(){
                self.delegate?.responseWithNoLocationEnabled(show:false)
                self.requestUpdateLocation()
            }else{
                self.delegate?.responseWithNoLocationEnabled(show:true)
            }
        }
    }
    
    func requestUpdateLocation(){
        self.locationManager.requestLocationUpdate(completion: { (long, lat) in
            self.locationManager.requestPlaceFromUserLocation(userLat: lat, userLong: long, completion: { (user, error) in
                guard error == nil else{
                    self.delegate?.configureWithPlace(currentPlace: self.locationManager.getDefaultUserPlace(), needAnimation: false, currentState: .errorRetrieve)
                    return
                }
                
                let coordinate₀ = CLLocation(latitude: lat, longitude: long)
                let coordinate₁ = CLLocation(latitude: RankeetDefines.Location.defaultLat, longitude: RankeetDefines.Location.defaultLong)
                let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                if (distanceInMeters/1000) > RankeetDefines.Location.maxDistanteKmFromMadridCenter{
                    self.delegate?.configureWithPlace(currentPlace: self.locationManager.getDefaultUserPlace(), needAnimation: false, currentState: .farAwayFromCenter)
                    return
                }
                
                if let currentPlace = user {
                    self.delegate?.configureWithPlace(currentPlace: currentPlace, needAnimation: true, currentState: .correctResponse)
                }
            })
        })
    }
    
    func requestFromMessageLocation(){
        if self.locationManager.needToRequestLocation(){
            self.requestLocation()
        }else{
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                self.checkingLocationFromSettings = true
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func responseNotLocationEnabled(){
        self.delegate?.responseWithNoLocationEnabled(show:true)
    }
    
    func changeLocationAction(){
        self.transitionToChangeLocation()
    }
    
    func addFiltersAction(){
        self.transitionToAddFilters()
    }
    
    //
    // MARK: - request methods
    //
    
    func requestMainFacilitiesWithPlace(currentPlace:UserPlace){
        self.delegate?.showLoadingFacilities()
        self.facilitiesManager.getListFacilitiesWithPlace(currentPlace: currentPlace) { (facilities, error) in
            self.delegate?.hideLoadingFacilities(completionLoading: { (completion) in
                if error != nil {
                    self.delegate?.showMessageNoFacilitiesInfoError()
                }else{
                    if let currentFacilities = facilities?.objects{
                        self.delegate?.loadFacilities(facilities: currentFacilities)
                    }
                }
            })
        }
    }
    
    func requestMainFacilitiesWithRegion(currentRegion:MKCoordinateRegion){
        self.delegate?.showLoadingFacilities()
        self.locationManager.requestPlaceFromUserLocation(userLat: currentRegion.center.latitude, userLong: currentRegion.center.longitude, completion: { (user, error) in
            if let currentPlace = user {
                self.delegate?.configureWithPlaceFromMap(currentPlace: currentPlace)
                self.facilitiesManager.getListFacilitiesWithRegion(region: currentRegion, completion: { (facilities, error) in
                    self.delegate?.hideLoadingFacilities(completionLoading: { (completion) in
                        if error != nil {
                            self.delegate?.showMessageNoFacilitiesInfoError()
                        }else{
                            if let currentFacilities = facilities?.objects{
                                self.delegate?.loadFacilities(facilities: currentFacilities)
                            }
                        }
                    })
                })
            }else{
                self.delegate?.hideLoadingFacilities(completionLoading: { (completion) in
                    self.delegate?.showMessageNoFacilitiesInfoError()
                })
            }
        })
    }
    
    //
    // MARK: - filter methods
    //
    func isAnyFilterEnabled()->Bool{
        return self.facilitiesManager.isAnyFilterEnabled()
    }
    
    //
    // MARK: - Map methods
    //
    
    func mapButtonAction(currentOffset:CGFloat){
        if currentOffset <= (-DevDefines.Metrics.insetViewMap+1) {
            self.delegate?.hideMapMode()
        }else{
            self.delegate?.showMapMode()
        }
    }
    
    func checkMapButtonState(currentOffset:CGFloat){
        if currentOffset <= (-DevDefines.Metrics.insetViewMap+1){
            self.delegate?.configureListButton()
        }else{
            self.delegate?.configureMapButton()
        }
    }
}


//
// MARK: - Transition Methods
//

extension FacilitiesPresenter{
    
    func transitionToChangeLocation(){
        let changeLocationViewController:ChangeLocationViewController = ChangeLocationViewController.instantiate()
        RouterManager.shared.visibleViewController?.present(changeLocationViewController, animated: true, completion: {
        })
    }
    
    func transitionToAddFilters(){
        let searchFiltersViewController:SearchFiltersViewController = SearchFiltersViewController.instantiate()
        RouterManager.shared.visibleViewController?.present(searchFiltersViewController, animated: true, completion: {
        })
    }
    
    func transitionToFacilityDetail(currentFacility:AlFacility, currentPlace:UserPlace, needTransition:Bool){
        let facilityFlexibleHeaderContainerViewController:FacilityFlexibleHeaderContainerViewController = FacilityFlexibleHeaderContainerViewController(currentFacility:currentFacility,currentPlace:currentPlace,fromOnboarding:false)
        if needTransition {
            facilityFlexibleHeaderContainerViewController.isHeroEnabled = true
        }
        RouterManager.shared.visibleViewController?.present(facilityFlexibleHeaderContainerViewController, animated: true, completion: nil)
    }
}

