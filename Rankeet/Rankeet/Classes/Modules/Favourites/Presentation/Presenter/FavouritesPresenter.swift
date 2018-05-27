//
//  BookingPresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

protocol FavouritesPresenterDelegate: NSObjectProtocol {
    func configureView()
    
    func showNoResultsView()
    func hideNoResultsView()
    func showLoadingFacilities()
    func hideLoadingFacilities(completionLoading:@escaping (Bool?) -> Void)
    
    func loadInfoTableView(currentFacilities:[AlFacility])
}

class FavouritesPresenter: NSObject {
    
    private weak var delegate: FavouritesPresenterDelegate?
    private var favouritesManager : FavouritesManager!
    
    init(delegate: FavouritesPresenterDelegate) {
        self.delegate = delegate
        self.favouritesManager = FavouritesManager()
    }
    
    //
    // MARK: - Public methods
    //
    func viewDidAppear(){
        self.delegate?.configureView()
        self.delegate?.showLoadingFacilities()
    }
    
    func viewWillAppear(){
        self.requestFavourites()
    }
    
    func selectFacilityFromUser(currentFacility: AlFacility){
        self.transitionToFacilityDetail(currentFacility: currentFacility)
    }
    
    //
    // MARK: - Request methods
    //
    func requestFavourites(){
        self.favouritesManager.getFacilitiesFavourites { (facilities, error) in
            self.delegate?.hideLoadingFacilities(completionLoading: { (completionLoading) in
                guard error == nil, facilities != nil, facilities!.count > 0 else {
                    self.delegate?.showNoResultsView()
                    return
                }
                self.delegate?.hideNoResultsView()
                self.delegate?.loadInfoTableView(currentFacilities: facilities!)
            })
        }
    }
}

//
// MARK: - Transition Methods
//

extension FavouritesPresenter {

    func transitionToFacilityDetail(currentFacility:AlFacility){
        var locationToDetail = LocationManager().getDefaultUserPlace()
        if let currentLocation = LocationManager().requestCurrentPlace() {
            locationToDetail = currentLocation
        }
        let facilityFlexibleHeaderContainerViewController:FacilityFlexibleHeaderContainerViewController = FacilityFlexibleHeaderContainerViewController(currentFacility:currentFacility,currentPlace:locationToDetail,fromOnboarding:false)
        facilityFlexibleHeaderContainerViewController.isHeroEnabled = true
        RouterManager.shared.visibleViewController?.present(facilityFlexibleHeaderContainerViewController, animated: true, completion: nil)
    }
}
