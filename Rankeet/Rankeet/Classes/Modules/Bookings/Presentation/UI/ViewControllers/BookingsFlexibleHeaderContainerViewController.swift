//
//  BookingsFlexibleHeaderContainerViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialFlexibleHeader

class BookingsFlexibleHeaderContainerViewController: MDCFlexibleHeaderContainerViewController {

    var needLightStatus:Bool = false
    
    init() {
        let bookingViewController:BookingViewController = BookingViewController.instantiate()
        
        super.init(contentViewController: bookingViewController)
        bookingViewController.delegate = self
        bookingViewController.headerViewController = self.headerViewController
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
    
    func relaodBookingsAction(){
        if let currentController = self.contentViewController as? BookingViewController {
            currentController.reloadBookings()
        }
    }
}

extension BookingsFlexibleHeaderContainerViewController: BookingViewControllerDelegate{
    
    func needToUpdateStatusBar(needLight: Bool) {
        self.needLightStatus = needLight
        self.setNeedsStatusBarAppearanceUpdate()
    }
}

