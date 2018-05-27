//
//  BookingDetailViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 20/4/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import PopupDialog
import MaterialComponents.MaterialFlexibleHeader

protocol BookingDetailViewControllerDelegate: NSObjectProtocol {
    func needToUpdateStatusBar(needLight:Bool)
}

class BookingDetailViewController: RankeetViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    var headerViewController: MDCFlexibleHeaderViewController!
    fileprivate var headerContentView:BookingsHeaderDetailView!
    
    weak var delegate: BookingDetailViewControllerDelegate?
    
    fileprivate var bookingDetailPresenter: BookingDetailPresenter?
    fileprivate var prevOpacity:CGFloat = 1.0
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var extendButton: UIButton!
    @IBOutlet weak var addIssueButton: UIButton!
    @IBOutlet weak var bookAgainButton: UIButton!
    
    @IBOutlet weak var remaingTime: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var facilityNameLabel: UILabel!
    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var labelTypology: UILabel!
    @IBOutlet weak var imageTypology: UIImageView!
    
    static func instantiate(currentReservation:AlLightReservation) -> BookingDetailViewController{
        let BookingsStoryBoard = UIStoryboard(name: "Bookings", bundle: nil)
        let bookingDetailViewController = BookingsStoryBoard.instantiateViewController(withIdentifier:"BookingDetailViewController") as! BookingDetailViewController
        bookingDetailViewController.bookingDetailPresenter = BookingDetailPresenter(delegate: bookingDetailViewController, currentReservation: currentReservation)
        return bookingDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cancelButton.setTitle("  "+String.bookings_detail_action_cancel, for: .normal)
        self.extendButton.setTitle("  "+String.bookings_detail_action_extend, for: .normal)
        self.addIssueButton.setTitle("  "+String.bookings_detail_action_add_issue, for: .normal)
        self.bookAgainButton.setTitle("  "+String.bookings_detail_action_book_again, for: .normal)
        
        self.bookingDetailPresenter?.viewDidAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sizeHeaderView()
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.showAlert(message: String.bookings_cancel_message, title: String.bookings_cancel_title, buttonCancel: String.generic_cancel, buttonRight: String.generic_accept) { (accept) in
            if accept! {
                self.showAlert(message: String.bookings_cancel_message, title: String.bookings_cancel_title, buttonCancel: String.generic_cancel, buttonRight: String.generic_accept) { (accept) in
                    if accept! {
                        self.showCancelOptions(completion: { (reason) in
                            self.bookingDetailPresenter?.cancelAction(currentReason: reason)
                        })
                    }
                }
            }
        }
    }
    
    func showCancelOptions(completion:@escaping (String) -> Void){
        let popup = PopupDialog(title:  String.bookings_cancel_title, message: String.bookings_detail_switch_off_message)
        // This button will not the dismiss the dialog
        for i in 1...5 {
            let currentButton = DefaultButton(title: NSLocalizedString("bookings_detail_switch_off_option_\(i)"), dismissOnTap: true) {
                completion(NSLocalizedString("bookings_detail_switch_off_option_\(i)"))
            }
            popup.addButton(currentButton)
        }
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    @IBAction func extendAction(_ sender: Any) {
        self.bookingDetailPresenter?.extendAction()
    }
    
    @IBAction func addIssueAction(_ sender: Any) {
        self.bookingDetailPresenter?.addIssueAction()
    }
    
    @IBAction func bookAgainAction(_ sender: Any) {
        self.bookingDetailPresenter?.bookAgainAction()
    }
    
    
    //
    // MARK: - Header methods
    //
    
    func sizeHeaderView() {
        let headerView = headerViewController.headerView
        let bounds = UIScreen.main.bounds
        if bounds.size.width < bounds.size.height {
            headerView.maximumHeight = DevDefines.Metrics.HeaderView.maxSizeBookingsDetail
        } else {
            headerView.maximumHeight = DevDefines.Metrics.HeaderView.minSizeBookings
        }
        headerView.minimumHeight = DevDefines.Metrics.HeaderView.minSizeBookings
    }
    func setupHeaderView() {
        self.loadHeaderView()
        
        let headerView = headerViewController.headerView
        headerView.trackingScrollView = self.contentScrollView
        headerView.maximumHeight = DevDefines.Metrics.HeaderView.maxSizeBookingsDetail
        headerView.minimumHeight = DevDefines.Metrics.HeaderView.minSizeBookings
        headerView.minMaxHeightIncludesSafeArea = false
        headerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerContentView.frame = (headerView.bounds)
        headerContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerView.addSubview(headerContentView)
    }
    func loadHeaderView() {
        if let views = Bundle.main.loadNibNamed("BookingsHeaderDetailView", owner: self, options: nil) as? [BookingsHeaderDetailView], views.count > 0, let currentView = views.first{
            self.headerContentView = currentView
            self.headerContentView.delegate = self
        }
    }
}

// MARK: UIScrollViewDelegate

extension BookingDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == headerViewController.headerView.trackingScrollView {
            headerViewController.headerView.trackingScrollDidScroll()
        }
        let scrollOffsetY = scrollView.contentOffset.y
        var opacity: CGFloat = 1.0
        if scrollOffsetY > -(DevDefines.Metrics.HeaderView.maxSizeBookingsDetail/2.0) {
            opacity = 0
        }
        if self.headerContentView != nil {
            self.headerContentView.opacityAction(currentOpacity: opacity)
            if self.prevOpacity != opacity {
                if self.prevOpacity > opacity {
                    self.delegate?.needToUpdateStatusBar(needLight: true)
                }else{
                    self.delegate?.needToUpdateStatusBar(needLight: false)
                }
                self.prevOpacity = opacity
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == headerViewController.headerView.trackingScrollView {
            headerViewController.headerView.trackingScrollDidEndDecelerating()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let headerView = headerViewController.headerView
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollDidEndDraggingWillDecelerate(decelerate)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let headerView = headerViewController.headerView
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollWillEndDragging(withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }
}

extension BookingDetailViewController: BookingDetailPresenterDelegate {
    
    func showExtendRequestDialog(currentReservation:AlLightReservation,currentMinutes: String) {
        self.showAlert(message: String.bookings_extend_message, title: String.bookings_extend_title, buttonCancel: String.generic_cancel, buttonRight: String.bookings_detail_action_extend+" "+currentMinutes) { (accept) in
            if accept! {
                self.bookingDetailPresenter?.extendReservation(currentReservation: currentReservation)
            }
        }
    }
    
    func showPreErrorRequestDialog(){
        self.showAlert(message: String.bookings_extend_message_error, title: String.bookings_extend_title, buttonCancel: String.generic_cancel, buttonRight: String.generic_accept) { (accept) in
            if accept! {
            }
        }
    }
    
    func configureHeaderView() {
        self.setupHeaderView()
    }
    
    func configureContentWithFacility(currentReservation:AlLightReservation, currentFacility: AlFacility) {
        UIView.animate(withDuration: 0.4, animations: {
            self.contentView.alpha = 1.0
            self.contentScrollView.alpha = 1.0
        }) { (completion) in
        }
        
        self.facilityNameLabel.text = currentReservation.nameFacility
        self.fieldName.text = currentReservation.nameField
        self.adress.text = currentFacility.info?.address
        
        self.imageTypology.image = nil
        self.labelTypology.text = String.facility_cell_typology_no_Rankeet
        if FacilitiesManager().isRankeetLightingInFacility(currentFacility: currentFacility){
            if FacilitiesManager().isRankeetLightingOnInFacility(currentFacility: currentFacility){
                self.labelTypology.text = String.facility_cell_typology_Rankeet_lighting_on
                self.imageTypology.image = UIImage(named:"imgCardLightson")
            }else{
                self.labelTypology.text = String.facility_cell_typology_Rankeet_lighting_off
                self.imageTypology.image = UIImage(named:"imgCardLightsoff")
            }
        }
        if let currentPrice = currentReservation.lightPriceField, currentPrice.count > 0, let currentPriceNumber = Int(currentPrice), currentPriceNumber > 0 {
            self.priceLabel.text = String.bookings_summary_price+" \(currentPriceNumber/100)€"
        }else{
            self.priceLabel.text = String.bookings_free_reservation
        }
        
        let currentFormatter = DateFormatter()
        currentFormatter.dateFormat = "HH:mm"
        
        if let start = currentReservation.timeStart, let end = currentReservation.timeEnd {
            self.hoursLabel.text = String.bookings_from+" \(currentFormatter.string(from: start)) "+String.bookings_to+" \(currentFormatter.string(from: end)) h"
            
            if let currentState = currentReservation.state {
                switch currentState {
                case .cancelled_while, .cancelled_before, .deleted:
                    self.configureButtonsWithFinished()
                    self.remaingTime.text = String.bookings_detail_state_cancelled
                default:
                    if let diffInMin = Calendar.current.dateComponents([.minute], from: Date(), to: start).minute {
                        if diffInMin > 60 {
                            self.configureButtonsWithNotYet()
                            let currentHour:Int = diffInMin/60
                            self.remaingTime.text = String.bookings_remains+" \(currentHour) "+String.bookings_hours+" "+String.generic_and+" \(diffInMin-(currentHour*60)) "+String.bookings_mins
                        }else{
                            if diffInMin < 0 {
                                if start < Date() && end > Date() {
                                    self.configureButtonsWithCurrent()
                                    self.remaingTime.text = String.bookings_detail_state_in_progress
                                }else{
                                    self.configureButtonsWithFinished()
                                    self.remaingTime.text = String.bookings_detail_state_finished
                                }
                            }else{
                                self.configureButtonsWithNotYet()
                                self.remaingTime.text = String.bookings_remains+" \(diffInMin) "+String.bookings_mins
                            }
                        }
                    }
                }
            }else{
                self.remaingTime.isHidden = true
            }
            
        }else{
            self.hoursLabel.text = ""
            self.remaingTime.text = ""
        }
    }
    
    func configureButtonsWithFinished(){
        self.cancelButton.isEnabled = false
        self.cancelButton.alpha = 0.5
        self.extendButton.isEnabled = false
        self.extendButton.alpha = 0.5
    }
    
    func configureButtonsWithNotYet(){
        self.extendButton.isEnabled = false
        self.extendButton.alpha = 0.5
    }
    
    func configureButtonsWithCurrent(){
        self.cancelButton.setTitle("  "+String.bookings_detail_action_turn_off, for: .normal)
    }
    
    
    
    func showLoadingDetail() {
        self.showLoadingView()
    }
    
    func hideLoadingDetail(completionLoading: @escaping (Bool?) -> Void) {
        self.hideLoadingView { (completion) in
            completionLoading(completion)
        }
    }
    
    func showErrorAction() {
        self.showAlert(message: String.bookings_generic_error_message, title: String.bookings_generic_error_title, buttonCancel: String.generic_accept, buttonRight: nil) { (accept) in
        }
    }
}

extension BookingDetailViewController: BookingsHeaderDetailViewDelegate {
    func backFromDetailHeader() {
        self.bookingDetailPresenter?.backTransition(needReload: false)
    }
}
