//
//  OnboardingSelectFacilityPresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

protocol OnboardingSelectFacilityPresenterDelegate: NSObjectProtocol {
    func showLoadingFacilities()
    func hideLoadingFacilities(completionLoading: @escaping (Bool?) -> Void)
    func showMessageNoFacilitiesInfoError()
    func loadFacilities(facilities:[AlFacility])
    func configureHeaderView()
}

class OnboardingSelectFacilityPresenter: NSObject {
    private weak var delegate: OnboardingSelectFacilityPresenterDelegate?
    private var facilitiesManager : FacilitiesManager!
    
    init(delegate: OnboardingSelectFacilityPresenterDelegate) {
        self.facilitiesManager = FacilitiesManager()
        self.delegate = delegate
    }
    
    //Public methods
    func dismissFromUser(){
        self.transitionToPrevScreen()
    }
    
    func viewDidload(){
        self.delegate?.showLoadingFacilities()
        self.facilitiesManager.getCompleteListFacilitiesWithRankeet { (facilities, error) in
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
        self.delegate?.configureHeaderView()
    }
}


//
// MARK: - Transition Methods
//

extension OnboardingSelectFacilityPresenter{
    func transitionToPrevScreen(){
        RouterManager.shared.visibleViewController?.dismiss(animated: true, completion: {
        })
    }
}


