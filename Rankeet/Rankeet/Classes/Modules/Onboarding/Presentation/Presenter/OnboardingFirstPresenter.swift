//
//  OnboardingFirstPresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

protocol OnboardingFirstPresenterDelegate: NSObjectProtocol {
    func animateViewsAppear()
    func animateViewsDismiss()
}

class OnboardingFirstPresenter: NSObject {
    private weak var delegate: OnboardingFirstPresenterDelegate?
    private var navigationDelegate: OnboardingIntroNavigationDelegate?
    
    init(delegate: OnboardingFirstPresenterDelegate,navigationDelegate:OnboardingIntroNavigationDelegate) {
        self.delegate = delegate
        self.navigationDelegate = navigationDelegate
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
}
