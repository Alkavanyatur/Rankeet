//
//  OnboardingSecondPresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

protocol OnboardingSecondPresenterDelegate: NSObjectProtocol {
    func animateViewsAppear()
    func animateViewsDismiss()
}

class OnboardingSecondPresenter: NSObject {
    
    private weak var delegate: OnboardingSecondPresenterDelegate?
    private var navigationDelegate: OnboardingIntroNavigationDelegate?
    
    private var onboardingManager : OnboardingManager!
    private var locationManager : LocationManager!
    private var facilitiesManager : FacilitiesManager!
    
    init(delegate: OnboardingSecondPresenterDelegate,navigationDelegate:OnboardingIntroNavigationDelegate) {
        self.delegate = delegate
        self.navigationDelegate = navigationDelegate
        
        self.locationManager = LocationManager()
        self.onboardingManager = OnboardingManager()
        self.facilitiesManager = FacilitiesManager()
    }
    
    //Public methods
    func viewDidLoad(){
        self.delegate?.animateViewsAppear()
    }
    
    func dismissActionFromNavigation(){
        self.delegate?.animateViewsDismiss()
    }

    func animationInPresentComplete(){
        self.navigationDelegate?.animationPresentComplete()
    }
    func animationInDismissComplete(){
        self.navigationDelegate?.animationDismissComplete()
    }
    
    func declineFromUser(){
        self.navigationDelegate?.transitionToSelectPlaceManually()
    }
    
    func continueFromUser(){
        self.locationManager.requestLocation { (enabled) in
            if (enabled){
                self.requestUpdateLocation()
            }else{
                self.navigationDelegate?.showMessageNoFacilitiesInfoError()
            }
        }
    }
    
    func transitionFromUserWithFacility(currentFacility:AlFacility){
        self.navigationDelegate?.transitionToNextOnboarding(facilitiy:currentFacility)
    }
    
    func requestUpdateLocation(){
        self.navigationDelegate?.showLoading()
        self.locationManager.requestLocationUpdate(completion: { (long, lat) in
            self.locationManager.requestPlaceFromUserLocation(userLat: lat, userLong: long, completion: { (user, error) in
                if let currentPlace = user {
                    self.facilitiesManager.getListNearFacilitiesWithRankeet(currentPlace: currentPlace) { (facilities, error) in
                        self.navigationDelegate?.hideLoading(completionLoading: { (completion) in
                            if let currentFacilities = facilities?.objects, currentFacilities.count > 0{
                                self.navigationDelegate?.transitionToNextOnboarding(facilitiy:currentFacilities[0])
                            }else{
                                self.navigationDelegate?.showMessageNoFacilitiesInfoError()
                            }
                        })
                    }
                }else{
                    self.navigationDelegate?.hideLoading(completionLoading: { (completion) in
                        self.navigationDelegate?.showMessageNoFacilitiesInfoError()
                    })
                }
            })
        })
    }
}

//
// MARK: - Transition Methods
//

extension OnboardingSecondPresenter{

}

