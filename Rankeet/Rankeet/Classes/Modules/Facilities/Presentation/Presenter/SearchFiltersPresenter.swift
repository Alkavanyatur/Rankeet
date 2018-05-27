//
//  SearchFiltersPresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

protocol SearchFiltersPresenterDelegate: NSObjectProtocol {
    func showSportsFilters(currentSports:[ConfigSports])
}

class SearchFiltersPresenter: NSObject {
    private weak var delegate: SearchFiltersPresenterDelegate?
    private var facilitiesManager : FacilitiesManager!
    private var splashManager : SplashManager!
    private var currentSports : [ConfigSports]!
    
    init(delegate: SearchFiltersPresenterDelegate) {
        self.delegate = delegate
        self.facilitiesManager = FacilitiesManager()
        self.splashManager = SplashManager()
    }
    
    //
    // MARK: - Public methods
    //
    func viewDidAppear(){
        self.facilitiesManager.restartScreenFilters()
        self.currentSports = self.splashManager.requestConfigSports()
        self.delegate?.showSportsFilters(currentSports: currentSports)
    }
    
    func closeFilterScreen(){
        self.transitionToPrevScreen(needToApply: false)
    }
    
    func applyFiltersAction(){
        self.facilitiesManager.applyFiltersToStored()
        self.transitionToPrevScreen(needToApply: true)
    }
    
    func needToEnableSportFilter(currentFilter:Int)->Bool{
        for sport in self.currentSports {
            if sport.idFilter == currentFilter {
                return self.facilitiesManager.isSportFilterEnabled(currentFilter: sport)
            }
        }
        return false
    }
    func needToEnableLightingFilter(currentFilter:Int)->Bool{
        switch currentFilter {
        case 101:
            return self.facilitiesManager.isLightingFilterEnabled(currentFilter: FilterStatesLighting.Rankeet)
        case 102:
            return self.facilitiesManager.isLightingFilterEnabled(currentFilter: FilterStatesLighting.others)
        default:
            return self.facilitiesManager.isLightingFilterEnabled(currentFilter: FilterStatesLighting.nolighting)
        }
    }
    func needToEnableSizeFilter(currentFilter:Int)->Bool{
        switch currentFilter {
        case 101:
            return self.facilitiesManager.isSizeFilterEnabled(currentFilter: FilterStatesSize.manyCourts)
        default:
            return false
        }
    }
    func interactWithSportFilter(currentFilter:Int){
        for sport in currentSports {
            if sport.idFilter == currentFilter {
                self.facilitiesManager.interactWithSportFilter(currentSports: sport)
            }
        }
    }
    func interactWithLightingFilter(currentFilter:Int){
        switch currentFilter {
        case 101:
            self.facilitiesManager.interactWithLightingFilter(lightingFilter:FilterStatesLighting.Rankeet)
        case 102:
            self.facilitiesManager.interactWithLightingFilter(lightingFilter:FilterStatesLighting.others)
        default:
            self.facilitiesManager.interactWithLightingFilter(lightingFilter:FilterStatesLighting.nolighting)
        }
    }
    func interactWithsizeFilter(currentFilter:Int){
        switch currentFilter {
        case 101:
            self.facilitiesManager.interactWithsizeFilter(sizeFilter:FilterStatesSize.manyCourts)
        default:
            return
        }
    }
}

//
// MARK: - Transition Methods
//

extension SearchFiltersPresenter{
    func transitionToPrevScreen(needToApply:Bool){
        RouterManager.shared.visibleViewController?.dismiss(animated: true, completion: {
            if needToApply {
                if let mainStructureController = RouterManager.shared.visibleViewController as? MainStructureViewController, let facilitiesViewController = (mainStructureController.selectedViewController as? UINavigationController)?.visibleViewController as? FacilitiesViewController, let place = facilitiesViewController.currentPlace  {
                    facilitiesViewController.configureWithPlace(currentPlace: place, needAnimation: true, currentState: .correctResponse)
                }
            }
        })
    }
}
