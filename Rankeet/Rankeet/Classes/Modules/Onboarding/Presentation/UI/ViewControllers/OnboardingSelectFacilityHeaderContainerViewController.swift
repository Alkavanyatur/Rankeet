//
//  OnboardingSelectFacilityHeaderContainerViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 17/4/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialFlexibleHeader

protocol OnboardingSelectFacilityHeaderContainerViewControllerDelegate: NSObjectProtocol {
    func selectFacilityFromUser(currentFacility: AlFacility)
}

class OnboardingSelectFacilityHeaderContainerViewController: MDCFlexibleHeaderContainerViewController {
    
    weak var delegate: OnboardingSelectFacilityHeaderContainerViewControllerDelegate?
    var needLightStatus:Bool = false

    init() {
        let onboardingSelectFacilityViewController:OnboardingSelectFacilityViewController = OnboardingSelectFacilityViewController.instantiate()
        
        super.init(contentViewController: onboardingSelectFacilityViewController)
        onboardingSelectFacilityViewController.delegate = self
        onboardingSelectFacilityViewController.headerViewController = self.headerViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.needLightStatus{
            return .lightContent
        }else{
            return .lightContent
        }
    }
}

extension OnboardingSelectFacilityHeaderContainerViewController: OnboardingSelectFacilityViewControllerDelegate{
    
    func needToUpdateStatusBar(needLight: Bool) {
        self.needLightStatus = needLight
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func selectFacilityFromUser(currentFacility: AlFacility) {
        self.delegate?.selectFacilityFromUser(currentFacility: currentFacility)
    }
}
