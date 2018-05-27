//
//  FacilityFeedbackPresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 9/4/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

protocol FacilityActionDelegate: NSObjectProtocol {
    func finalActionStepAndBackToReservations()
}

protocol FacilityFeedbackPresenterDelegate: NSObjectProtocol {
    func showFeedbackInfoAnimation()
}

class FacilityFeedbackPresenter: NSObject {
    
    private weak var delegate: FacilityFeedbackPresenterDelegate?
    private weak var delegateNavigation: FacilityActionDelegate?
    
    init(delegate: FacilityFeedbackPresenterDelegate, delegateNavigation: FacilityActionDelegate?) {
        self.delegateNavigation = delegateNavigation
        self.delegate = delegate
    }
    
    func viewDidLoad(){
        self.delegate?.showFeedbackInfoAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + DevDefines.Delay.delayToRemoveFeedback) {
            self.transitionToMyReservations()
        }
    }
}

//
// MARK: - Transition Methods
//

extension FacilityFeedbackPresenter{
    func transitionToMyReservations(){
        self.delegateNavigation?.finalActionStepAndBackToReservations()
    }
}
