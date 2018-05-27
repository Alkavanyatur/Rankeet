//
//  FacilitySummaryPresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

protocol FacilitySummaryPresenterDelegate: NSObjectProtocol {
    
    func configureBodyWithReservation(currentReservation:AlLightReservation)
    
    func showLoadingReservation()
    func hideLoadingReservation(completionLoading:@escaping (Bool?) -> Void)
    
    func showErrorMessageReservation()
    func showEnjoyFeedback()
}

class FacilitySummaryPresenter: NSObject {
    
    private var facilitiesManager : FacilitiesManager!
    private weak var delegate: FacilitySummaryPresenterDelegate?
    private var lightReservation : AlLightReservation?
    
    init(delegate: FacilitySummaryPresenterDelegate, lightReservation: AlLightReservation?) {
        self.lightReservation = lightReservation
        self.delegate = delegate
        self.facilitiesManager = FacilitiesManager()
    }
    
    func viewDidLoad(){
        if let currentReservation = self.lightReservation {
            self.delegate?.configureBodyWithReservation(currentReservation: currentReservation)
        }
    }
    
    func confirmAction(){
        if let reservation = self.lightReservation {
            self.delegate?.showLoadingReservation()
        }else{
            self.delegate?.showErrorMessageReservation()
        }
    }
    
    func cancelAction(){
        self.transitionToBackDetail()
    }
}

//
// MARK: - Transition Methods
//

extension FacilitySummaryPresenter{
    func showEnjoyFeedbackUser(){
        self.delegate?.showEnjoyFeedback()
    }
    func transitionToBackDetail(){
        RouterManager.shared.visibleViewController?.dismiss(animated: true, completion: nil)
    }
}

