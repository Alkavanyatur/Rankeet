//
//  FavouritesFlexibleHeaderContainerViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialFlexibleHeader

class FavouritesFlexibleHeaderContainerViewController: MDCFlexibleHeaderContainerViewController {

    var needLightStatus:Bool = false
    
    init() {
        let favouritesViewController:FavouritesViewController = FavouritesViewController.instantiate()
        
        super.init(contentViewController: favouritesViewController)
        favouritesViewController.delegate = self
        favouritesViewController.headerViewController = self.headerViewController
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

extension FavouritesFlexibleHeaderContainerViewController: FavouritesViewControllerDelegate{
    
    func needToUpdateStatusBar(needLight: Bool) {
        self.needLightStatus = needLight
        self.setNeedsStatusBarAppearanceUpdate()
    }
}

