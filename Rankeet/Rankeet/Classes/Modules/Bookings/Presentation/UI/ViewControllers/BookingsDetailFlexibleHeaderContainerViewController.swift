//
//  BookingsDetailFlexibleHeaderContainerViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 20/4/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialFlexibleHeader

protocol BookingsDetailFlexibleHeaderContainerViewControllerDelegate: NSObjectProtocol {
    func relaodBookingsAction()
}

class BookingsDetailFlexibleHeaderContainerViewController: MDCFlexibleHeaderContainerViewController {
    private weak var delegate: BookingsDetailFlexibleHeaderContainerViewControllerDelegate?
    var needLightStatus:Bool = false
    
    init(currentReservation:AlLightReservation, delegate:BookingsDetailFlexibleHeaderContainerViewControllerDelegate?) {
        self.delegate = delegate
        let bookingDetailViewController:BookingDetailViewController = BookingDetailViewController.instantiate(currentReservation: currentReservation)
        
        super.init(contentViewController: bookingDetailViewController)
        bookingDetailViewController.delegate = self
        bookingDetailViewController.headerViewController = self.headerViewController
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
        self.delegate?.relaodBookingsAction()
    }
}

extension BookingsDetailFlexibleHeaderContainerViewController: BookingDetailViewControllerDelegate{
    
    func needToUpdateStatusBar(needLight: Bool) {
        self.needLightStatus = needLight
        self.setNeedsStatusBarAppearanceUpdate()
    }
}
