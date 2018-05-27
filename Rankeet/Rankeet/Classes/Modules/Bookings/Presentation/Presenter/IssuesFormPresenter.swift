//
//  IssuesFormPresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 23/4/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

protocol IssuesFormPresenterDelegate: NSObjectProtocol {
    func configureView(currentReservation:AlLightReservation)
    
    func showCorrectIssue()
    func showErrorIssue()
    
    func showLoadingIssue()
    func hideLoadingIssue(completionLoading:@escaping (Bool?) -> Void)
}

class IssuesFormPresenter: NSObject {
    
    private weak var delegate: IssuesFormPresenterDelegate?
    private var bookingsManager : BookingsManager!
    
    private var currentReservation : AlLightReservation!
    
    init(delegate: IssuesFormPresenterDelegate, currentReservation:AlLightReservation) {
        self.delegate = delegate
        self.bookingsManager = BookingsManager()
        
        self.currentReservation = currentReservation
    }
    
    //
    // MARK: - Public methods
    //
    func viewDidAppear(){
        self.delegate?.configureView(currentReservation: self.currentReservation)
    }
    
    func backActionFromUser(){
        self.backTransition()
    }
    
    func uploadIssueText(currentIssue:String, currentSubject:String){
        let currentIssue = AlIssue(currentDate: Date(), idUser: "", idLightReservation: currentReservation.idLightingReservation!, subject: currentSubject, body: currentIssue)
        self.delegate?.showLoadingIssue()
        self.bookingsManager.createNewIssue(currentIssue: currentIssue) { (error) in
            self.delegate?.hideLoadingIssue(completionLoading: { (completion) in
                guard error == nil else {
                    self.delegate?.showErrorIssue()
                    return
                }
                self.delegate?.showCorrectIssue()
            })
        }
    }
}

//
// MARK: - Transition Methods
//

extension IssuesFormPresenter{
    
    func backTransition(){
        RouterManager.shared.visibleNavigationController?.popViewController(animated: true)
    }
}



