//
//  SportsSelectionPresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 21/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

protocol SportsSelectionPresenterDelegate: NSObjectProtocol {
    func configureListSports(currentSports:[Int])
}

protocol SportsSelectionNavigationDelegate: NSObjectProtocol {
    func selectSportFromUser(currentSports:Int)
}

class SportsSelectionPresenter: NSObject {
    
    private weak var currentFacility: AlFacility?
    private var facilitiesManager : FacilitiesManager!
    
    private weak var delegate: SportsSelectionPresenterDelegate?
    private weak var delegateNavigation: SportsSelectionNavigationDelegate?
    
    init(delegate: SportsSelectionPresenterDelegate, delegateNavigation: SportsSelectionNavigationDelegate?, currentFacility:AlFacility?) {
        self.currentFacility = currentFacility
        self.delegateNavigation = delegateNavigation
        self.delegate = delegate
        
        self.facilitiesManager = FacilitiesManager()
    }
    
    func viewDidLoad(){
        var currentSports:[Int] = []
        currentSports.append(RankeetDefines.ContentServices.Facilities.sportTypeAll)
        if let currentFields = currentFacility?.fields {
            for field in currentFields {
                guard let currentLightingDependencies = field.lightingDependencies, currentLightingDependencies.count > 0 else{
                    break
                }
                var found = false
                for currentElement in currentSports {
                    if currentElement == field.typeField {
                        found = true
                    }
                }
                if found == false {
                    currentSports.append(field.typeField)
                }
            }
        }
        self.delegate?.configureListSports(currentSports:currentSports)
    }
    
    func getNameSportByType(currentType:Int)-> String{
        if currentType == RankeetDefines.ContentServices.Facilities.sportTypeAll {
            return String.facility_sport_selection_any_sport
        }
        return self.facilitiesManager.getFacilitySportNameById(currentId: currentType)
    }
    
    func cancelAction(){
        self.transitionToBackDetail()
    }
    
    func selectSportType(currentSport:Int){
        self.delegateNavigation?.selectSportFromUser(currentSports: currentSport)
        self.transitionToBackDetail()
    }
}

//
// MARK: - Transition Methods
//

extension SportsSelectionPresenter{

    func transitionToBackDetail(){
        RouterManager.shared.visibleViewController?.dismiss(animated: true, completion: nil)
    }
}
