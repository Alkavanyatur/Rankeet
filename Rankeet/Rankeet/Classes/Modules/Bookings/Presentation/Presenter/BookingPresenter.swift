//
//  BookingPresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 16/1/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

protocol BookingPresenterDelegate: NSObjectProtocol {
    func configureHeaderView()
    func configureCollectionView()
    
    func showLoadingBookings()
    func hideLoadingBookings(completionLoading:@escaping (Bool?) -> Void)
    
    func showErrorAction()
    
    func loadInfoCollectionView(currentBookings:[AlLightReservation], oldBookings:[AlLightReservation])
    
    func showNoResultsView()
    func hideNoResultsView()
    
    func showExtendRequestDialog(currentReservation:AlLightReservation,currentMinutes:String)
    func showPreErrorRequestDialog()
}

class BookingPresenter: NSObject {
    
    private weak var delegate: BookingPresenterDelegate?
    private var bookingsManager : BookingsManager!
    private var splashManager : SplashManager!
    
    init(delegate: BookingPresenterDelegate) {
        self.delegate = delegate
        self.bookingsManager = BookingsManager()
        self.splashManager = SplashManager()
    }
    
    //
    // MARK: - Public methods
    //
    func viewDidAppear(){
        self.delegate?.configureCollectionView()
        self.delegate?.configureHeaderView()
        
        self.delegate?.showLoadingBookings()
        self.requestBookings()
    }
    
    func viewWillAppear(){
        if LoginManager().isUserWithLogin() == false{
            self.delegate?.showNoResultsView()
        }
    }
    
    func presentBookingDetail(currentBooking:AlLightReservation){
        self.transitionToBookingDetail(currentBooking: currentBooking)
    }
    
    //
    // MARK: - Request methods
    //
    func requestBookings(){
        self.bookingsManager.getLightingReservations { (reservations, error) in
            self.delegate?.hideLoadingBookings(completionLoading: { (completionLoading) in
                guard error == nil, reservations != nil, reservations!.count > 0 else {
                    self.delegate?.showNoResultsView()
                    return
                }
                if LoginManager().isUserWithLogin(){
                    self.delegate?.hideNoResultsView()
                    self.checkTimeReservationAndResponse(reservations: reservations!)
                }else{
                    self.delegate?.showNoResultsView()
                }
            })
        }
    }
    
    func checkTimeReservationAndResponse(reservations:[AlLightReservation]){
        var currentReservations:[AlLightReservation] = []
        var oldReservations:[AlLightReservation] = []
        for reservation in reservations {
            if let reservationState = reservation.state, let reservationTimeEnd = reservation.timeEnd {
                if ( reservationState == .created || reservationState == .paid ) && reservationTimeEnd > Date() {
                    currentReservations.append(reservation)
                }else{
                    oldReservations.append(reservation)
                }
            }
        }
        currentReservations = currentReservations.sorted(by: sorterForCurrentBookings)
        oldReservations = oldReservations.sorted(by: sorterForOldBookings)
        self.delegate?.loadInfoCollectionView(currentBookings: currentReservations, oldBookings: oldReservations)
    }
    
    func sorterForCurrentBookings(this:AlLightReservation, that:AlLightReservation) -> Bool {
        if let currentDate = this.timeStart, let thatDate = that.timeStart {
            return currentDate < thatDate
        }
        return false
    }
    
    func sorterForOldBookings(this:AlLightReservation, that:AlLightReservation) -> Bool {
        if let currentDate = this.timeStart, let thatDate = that.timeStart {
            return currentDate > thatDate
        }
        return false
    }
    
    func cancelLigintgReservation(reason:String, currentReservation:AlLightReservation){
        if let currentLightingReservation = currentReservation.idLightingReservation{
            self.delegate?.showLoadingBookings()
            self.bookingsManager.cancelLightingReservation(reason:reason, currentIdLightingreservation: currentLightingReservation) { (error) in
                guard error == nil else {
                    self.delegate?.hideLoadingBookings(completionLoading: { (completion) in
                        self.delegate?.showErrorAction()
                    })
                    return
                }
                self.requestBookings()
            }
        }
    }
    
    func checkNeedExtendReservation(currentReservation:AlLightReservation){
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
            self.delegate?.showLoadingBookings()
            self.bookingsManager.requestExtendLightingReservation(currentReservation: reservationToExtend) { (reservation, error) in
                guard error == nil else {
                    self.delegate?.hideLoadingBookings(completionLoading: { (completion) in
                        self.delegate?.showErrorAction()
                    })
                    return
                }
                self.requestBookings()
            }
        }
    }
}

//
// MARK: - Transition Methods
//

extension BookingPresenter: BookingsDetailFlexibleHeaderContainerViewControllerDelegate{
    func relaodBookingsAction() {
        self.delegate?.showLoadingBookings()
        self.requestBookings()
    }
}


//
// MARK: - Transition Methods
//

extension BookingPresenter{
    
    func transitionToBookingDetail(currentBooking:AlLightReservation){
        let bookingsDetailFlexibleHeaderContainerViewController:BookingsDetailFlexibleHeaderContainerViewController = BookingsDetailFlexibleHeaderContainerViewController(currentReservation: currentBooking,delegate:self)
        let navigationDetail = UINavigationController(rootViewController: bookingsDetailFlexibleHeaderContainerViewController)
        navigationDetail.isNavigationBarHidden = true
        
        RouterManager.shared.visibleViewController?.present(navigationDetail, animated: true, completion: {
        })
    }
}
