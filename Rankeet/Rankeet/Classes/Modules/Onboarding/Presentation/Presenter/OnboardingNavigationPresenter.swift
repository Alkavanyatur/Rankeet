//
//  OnboardingNavigationPresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

public protocol GenericControllerOnboardingProtocol {
    func dismissActionFromNavigation()
}

protocol OnboardingIntroNavigationDelegate: NSObjectProtocol {
    func animationPresentComplete()
    func animationDismissComplete()
    func goToNextStepFromInteralAction()
    
    func showLoading()
    func hideLoading(completionLoading: @escaping (Bool?) -> Void)
    func showMessageNoFacilitiesInfoError()
    
    func transitionToNextOnboarding(facilitiy:AlFacility)
    func transitionToSelectPlaceManually()
    func transitionToFacilityDetail(facility:AlFacility)
    
    func errorAndHide()
    func showCorrectMessageNFC(currentName:String)
}

protocol OnboardingNavigationPresenterDelegate: NSObjectProtocol {
    func presentOnboardingControllerStep(currentNumber:Int,facilitiy:AlFacility?)
    func changeButtonStepCurrentStep(currentNumber:Int)
    func setStepIndicator(currentNumber:Int)
    func reloadOnboardingWithFacility(facility:AlFacility)
}

class OnboardingNavigationPresenter: NSObject {
    fileprivate var currentState:Int = 1
    private weak var delegate: OnboardingNavigationPresenterDelegate?
    fileprivate var buttonsAreAvailable:Bool = false
    
    init(delegate: OnboardingNavigationPresenterDelegate) {
        self.delegate = delegate
    }
    
    //Public methods
    func viewDidLoad(){
        self.comunicatenState(currentFacility:nil)
    }
    
    func continueFromUser(currentFacility: AlFacility?){
        if currentState < 5{
            currentState = currentState+1
            self.comunicatenState(currentFacility:currentFacility)
        }else{
            self.transitionToMainStructure()
        }
    }
    
    func continueFromUserWithFacility(currentFacility:AlFacility){
        self.continueFromUser(currentFacility: currentFacility)
    }
    
    func comunicatenState(currentFacility:AlFacility?){
        self.delegate?.presentOnboardingControllerStep(currentNumber: self.currentState,facilitiy:currentFacility)
        self.delegate?.changeButtonStepCurrentStep(currentNumber: self.currentState)
        self.delegate?.setStepIndicator(currentNumber: self.currentState)
    }
    
    func dismissFromUser(){
        self.transitionToMainStructure()
    }
    
    func disableButtons(){
        self.buttonsAreAvailable = false
    }
    func enableButtons(){
        self.buttonsAreAvailable = true
    }
    func areButtonsEnabled()->Bool{
        return self.buttonsAreAvailable
    }
}

//
// MARK: - Transition Methods
//

extension OnboardingNavigationPresenter{
    func transitionToMainStructure(){
        let mainStructureViewController:MainStructureViewController = MainStructureViewController.instantiate()
        RouterManager.shared.visibleViewController?.dismiss(animated: true, completion: {
            RouterManager.shared.visibleViewController?.present(mainStructureViewController, animated: true, completion: {
            })
        })
    }

    func transitionToSelectPlaceManually(){
        let onboardingSelectFacilityHeaderContainerViewController:OnboardingSelectFacilityHeaderContainerViewController = OnboardingSelectFacilityHeaderContainerViewController()
        onboardingSelectFacilityHeaderContainerViewController.delegate = self
        RouterManager.shared.visibleViewController?.present(onboardingSelectFacilityHeaderContainerViewController, animated: true, completion: nil)
    }
    
    func transitionToFacilityDetail(facility:AlFacility){
        var locationToDetail = LocationManager().getDefaultUserPlace()
        if let currentLocation = LocationManager().requestCurrentPlace() {
            locationToDetail = currentLocation
        }
        let facilityFlexibleHeaderContainerViewController:FacilityFlexibleHeaderContainerViewController = FacilityFlexibleHeaderContainerViewController(currentFacility:facility,currentPlace:locationToDetail,fromOnboarding:true)
        facilityFlexibleHeaderContainerViewController.isHeroEnabled = true
        RouterManager.shared.visibleViewController?.present(facilityFlexibleHeaderContainerViewController, animated: true, completion: nil)
    }
}

extension OnboardingNavigationPresenter: OnboardingSelectFacilityHeaderContainerViewControllerDelegate {
    func selectFacilityFromUser(currentFacility: AlFacility) {
        self.delegate?.reloadOnboardingWithFacility(facility: currentFacility)
        RouterManager.shared.visibleViewController?.dismiss(animated: true, completion: {
            
        })
    }
}
