//
//  BookingDetailPresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 20/4/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

protocol BookingDetailPresenterDelegate: NSObjectProtocol {
    func configureHeaderView()
    func configureContentWithFacility(currentReservation:AlLightReservation, currentFacility: AlFacility)

    func showLoadingDetail()
    func hideLoadingDetail(completionLoading:@escaping (Bool?) -> Void)
    
    func showErrorAction()
    
    func showExtendRequestDialog(currentReservation:AlLightReservation,currentMinutes:String)
    func showPreErrorRequestDialog()
}

class BookingDetailPresenter: NSObject {
    private weak var delegate: BookingDetailPresenterDelegate?
    private var bookingsManager : BookingsManager!
    private var facilitiesManager : FacilitiesManager!
    private var splashManager : SplashManager!
    
    private var currentReservation : AlLightReservation!
    private var currentFacility : AlFacility?
    
    init(delegate: BookingDetailPresenterDelegate, currentReservation:AlLightReservation) {
        self.delegate = delegate
        self.currentReservation = currentReservation
        
        self.bookingsManager = BookingsManager()
        self.facilitiesManager = FacilitiesManager()
        self.splashManager = SplashManager()
    }
    
    //
    // MARK: - Public methods
    //
    func viewDidAppear(){
        self.delegate?.configureHeaderView()
        
        if let currentIdFacility = self.currentReservation.idFacility {
            self.delegate?.showLoadingDetail()
            self.requestDetail(currentId: currentIdFacility)
        }else{
            self.delegate?.showErrorAction()
        }
    }
    
    func cancelAction(currentReason:String){
        if let currentLightingReservation = currentReservation.idLightingReservation{
            self.delegate?.showLoadingDetail()
            self.bookingsManager.cancelLightingReservation(reason:currentReason, currentIdLightingreservation: currentLightingReservation) { (error) in
                guard error == nil else {
                    self.delegate?.hideLoadingDetail(completionLoading: { (completion) in
                        self.delegate?.showErrorAction()
                    })
                    return
                }
                self.backTransition(needReload: true)
            }
        }
    }
    
    func extendAction(){
        guard currentReservation.extend == nil else {
            self.delegate?.showPreErrorRequestDialog()
            return
        }
        if let startDate = currentReservation.timeStart, let endDate = currentReservation.timeEnd, startDate < endDate {
            let minutes = startDate.minutesEarlier(than: endDate)
            
            let timeGap = self.splashManager.requestGapTimeReservation()
            let numGaps = self.splashManager.requestNumGapAllowed()
            
            let currentGaps = minutes/timeGap
            if currentGaps >= numGaps, (((minutes+timeGap)/timeGap) <= numGaps) {
                self.delegate?.showPreErrorRequestDialog()
            }else{
                self.delegate?.showExtendRequestDialog(currentReservation:currentReservation,currentMinutes: "\(timeGap) min")
            }
        }
    }
    
    func extendReservation(currentReservation:AlLightReservation){
        let reservationToExtend = currentReservation.copy()  as! AlLightReservation
        if let endDate = reservationToExtend.timeEnd {
            let timeGap = self.splashManager.requestGapTimeReservation()
            reservationToExtend.timeStart = endDate
            reservationToExtend.timeEnd = endDate.add(timeGap.minutes)
            self.delegate?.showLoadingDetail()
            self.bookingsManager.requestExtendLightingReservation(currentReservation: reservationToExtend) { (reservation, error) in
                guard error == nil else {
                    self.delegate?.hideLoadingDetail(completionLoading: { (completion) in
                        self.delegate?.showErrorAction()
                    })
                    return
                }
                self.backTransition(needReload: true)
            }
        }
    }
    
    func addIssueAction(){
        self.transitionToCreateIssue(currentLightingReservation: self.currentReservation)
    }
    
    func bookAgainAction(){
        self.transitionToBookFacilityDetail()
    }
    
    //
    // MARK: - Request methods
    //
    func requestDetail(currentId:String){
        self.facilitiesManager.getFacilityDetail(currentIdFacility: currentId) { (facility, error) in
            self.delegate?.hideLoadingDetail(completionLoading: { (completionLoading) in
                guard error == nil, facility != nil else {
                    self.delegate?.showErrorAction()
                    return
                }
                self.currentFacility = facility
                self.delegate?.configureContentWithFacility(currentReservation: self.currentReservation, currentFacility: facility!)
            })
        }
    }
}

//
// MARK: - Transition Methods
//

extension BookingDetailPresenter{
    
    func backTransition(needReload:Bool){

        if let pastController = RouterManager.shared.visibleViewController as? BookingsDetailFlexibleHeaderContainerViewController  {
            if needReload {
                pastController.relaodBookingsAction()
            }
            pastController.dismiss(animated: true, completion: nil)
        }else{
            RouterManager.shared.visibleViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func transitionToBookFacilityDetail(){
        guard let facility = self.currentFacility else {
            return
        }
        var locationToDetail = LocationManager().getDefaultUserPlace()
        if let currentLocation = LocationManager().requestCurrentPlace() {
            locationToDetail = currentLocation
        }
        let facilityFlexibleHeaderContainerViewController:FacilityFlexibleHeaderContainerViewController = FacilityFlexibleHeaderContainerViewController(currentFacility:facility,currentPlace:locationToDetail,fromOnboarding:false)
        
        RouterManager.shared.visibleViewController?.dismiss(animated: true, completion: {
            RouterManager.shared.visibleViewController?.present(facilityFlexibleHeaderContainerViewController, animated: true, completion: nil)
        })
    }
    
    func transitionToCreateIssue(currentLightingReservation:AlLightReservation){
         let issuesFormViewController:IssuesFormViewController = IssuesFormViewController.instantiate(currentReservation: currentLightingReservation)
        RouterManager.shared.visibleNavigationController?.pushViewController(issuesFormViewController, animated: true)
    }
}

