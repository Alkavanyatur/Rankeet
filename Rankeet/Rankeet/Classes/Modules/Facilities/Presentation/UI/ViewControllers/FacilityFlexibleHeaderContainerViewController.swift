//
//  FacilityFlexibleHeaderContainerViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 19/3/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialFlexibleHeader

class FacilityFlexibleHeaderContainerViewController: MDCFlexibleHeaderContainerViewController {
    
    var needLightStatus:Bool = false

    init(currentFacility:AlFacility,currentPlace:UserPlace, fromOnboarding:Bool) {
        let facilityDetailViewController:FacilityDetailViewController = FacilityDetailViewController.instantiate(currentFacility: currentFacility,currentPlace: currentPlace,fromOnboarding: fromOnboarding)
        
        facilityDetailViewController.isHeroEnabled = true
        
        super.init(contentViewController: facilityDetailViewController)
        facilityDetailViewController.delegate = self
        facilityDetailViewController.headerViewController = self.headerViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.needLightStatus{
            return .lightContent
        }else{
            return .default
        }
    }
}

extension FacilityFlexibleHeaderContainerViewController: FacilityDetailViewControllerDelegate{
    
    func needToUpdateStatusBar(needLight: Bool) {
        self.needLightStatus = needLight
        self.setNeedsStatusBarAppearanceUpdate()
    }
}
