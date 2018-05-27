//
//  OnboardingThirdPresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

protocol OnboardingThirdPresenterDelegate: NSObjectProtocol {
    func configureWithFacility(currentFacility:AlFacility)
    func animateViewsAppear()
    func animateViewsDismiss()
}

class OnboardingThirdPresenter: NSObject {
    private weak var delegate: OnboardingThirdPresenterDelegate?
    private var navigationDelegate: OnboardingIntroNavigationDelegate?
    private var facility: AlFacility!
    
    init(delegate: OnboardingThirdPresenterDelegate, currentFacility:AlFacility,navigationDelegate:OnboardingIntroNavigationDelegate) {
        self.delegate = delegate
        self.navigationDelegate = navigationDelegate
        self.facility = currentFacility
    }
    
    //Public methods
    func viewDidLoad(){
        self.delegate?.configureWithFacility(currentFacility: self.facility)
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
        self.navigationDelegate?.transitionToNextOnboarding(facilitiy:self.facility)
    }
}
