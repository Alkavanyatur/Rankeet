//
//  BookingViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 16/1/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ViewAnimator
import PopupDialog
import MaterialComponents.MaterialFlexibleHeader


protocol BookingViewControllerDelegate: NSObjectProtocol {
    func needToUpdateStatusBar(needLight:Bool)
}

class BookingViewController: RankeetViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var headerViewController: MDCFlexibleHeaderViewController!
    fileprivate var headerContentView:BookingsHeaderView!
    
    @IBOutlet weak var noResultsView: UIView!
    weak var delegate: BookingViewControllerDelegate?

    fileprivate var bookingsPresenter: BookingPresenter?
    fileprivate var prevOpacity:CGFloat = 1.0
    
    fileprivate var currentBookings: [AlLightReservation] = []
    fileprivate var oldBookings: [AlLightReservation] = []
    
    fileprivate var alreadyRequestedBookings:Bool = false
    fileprivate var loadingByRefresh:Bool = false
    
    private let refreshControl = UIRefreshControl()
    
    static func instantiate() -> BookingViewController{
        let BookingsStoryBoard = UIStoryboard(name: "Bookings", bundle: nil)
        let bookingViewController = BookingsStoryBoard.instantiateViewController(withIdentifier:"bookingViewController") as! BookingViewController
        bookingViewController.bookingsPresenter = BookingPresenter(delegate: bookingViewController)
        return bookingViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bookingsPresenter?.viewDidAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.alreadyRequestedBookings = true
        sizeHeaderView()
        self.bookingsPresenter?.viewWillAppear()
    }
    
    @IBAction func reloadBookings(_ sender: Any) {
        self.reloadBookings()
    }
    
    
    //
    // MARK: - Public methods
    //
    func reloadBookings(){
        if self.alreadyRequestedBookings {
            self.showLoadingBookings()
            self.bookingsPresenter?.requestBookings()
        }
    }
    
    //
    // MARK: - Header methods
    //
    
    func sizeHeaderView() {
        let headerView = headerViewController.headerView
        let bounds = UIScreen.main.bounds
        if bounds.size.width < bounds.size.height {
            headerView.maximumHeight = DevDefines.Metrics.HeaderView.maxSizeBookings
        } else {
            headerView.maximumHeight = DevDefines.Metrics.HeaderView.minSizeBookings
        }
        headerView.minimumHeight = DevDefines.Metrics.HeaderView.minSizeBookings
    }
    func setupHeaderView() {
        self.loadHeaderView()
        
        let headerView = headerViewController.headerView
        headerView.trackingScrollView = self.collectionView
        headerView.maximumHeight = DevDefines.Metrics.HeaderView.maxSizeBookings
        headerView.minimumHeight = DevDefines.Metrics.HeaderView.minSizeBookings
        headerView.minMaxHeightIncludesSafeArea = false
        headerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerContentView.frame = (headerView.bounds)
        headerContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerView.addSubview(headerContentView)
    }
    func loadHeaderView() {
        if let views = Bundle.main.loadNibNamed("BookingsHeaderView", owner: self, options: nil) as? [BookingsHeaderView], views.count > 0, let currentView = views.first{
            self.headerContentView = currentView
        }
    }
}


//
// MARK: - CollectionView methods
//

extension BookingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func setupCollectionView() {
        self.collectionView.register(UINib(nibName: "OldBookingsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OldBookingsCollectionViewCell")
        self.collectionView.register(UINib(nibName: "CurrentBookingsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CurrentBookingsCollectionViewCell")
        
        self.collectionView.register(UINib(nibName: "EmptyCurrentBookingsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EmptyCurrentBookingsCollectionViewCell")
        self.collectionView.register(UINib(nibName: "BookingsHeaderCollectioViewCell", bundle: nil), forCellWithReuseIdentifier: "BookingsHeaderCollectioViewCell")

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1.0,height: 1.0)
        }
        self.collectionView.dataSource = self
        self.configurePullToRefresh()
    }
    
    func configurePullToRefresh(){
        if #available(iOS 10.0, *) {
            self.collectionView.refreshControl = self.refreshControl
        } else {
            self.collectionView.addSubview(self.refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(refreshBookingData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshBookingData(_ sender: Any) {
        self.loadingByRefresh = true
        self.bookingsPresenter?.requestBookings()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.currentBookings.count == 0 && self.oldBookings.count == 0 {
            return 0
        }else{
            if section == 0 {
                if self.currentBookings.count == 0 {
                    return 2
                }else{
                    return self.currentBookings.count+1
                }
            }else{
                if self.oldBookings.count == 0 {
                    return 0
                }else{
                    return self.oldBookings.count+1
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if self.currentBookings.count > 0 {
                self.bookingsPresenter?.presentBookingDetail(currentBooking: self.currentBookings[indexPath.row-1])
            }
        }else{
            if self.oldBookings.count > 0 {
                self.bookingsPresenter?.presentBookingDetail(currentBooking: self.oldBookings[indexPath.row-1])
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell? = nil
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingsHeaderCollectioViewCell", for: indexPath) as! BookingsHeaderCollectioViewCell
                if let currentCell = cell as? BookingsHeaderCollectioViewCell{
                    currentCell.configureWithSectiontitle(currentTitle: String.bookings_section_actives, isActive: true)
                }
            }else{
                if self.currentBookings.count == 0 {
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCurrentBookingsCollectionViewCell", for: indexPath) as! EmptyCurrentBookingsCollectionViewCell
                }else{
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrentBookingsCollectionViewCell", for: indexPath) as! CurrentBookingsCollectionViewCell
                    if let currentCell = cell as? CurrentBookingsCollectionViewCell{
                        currentCell.delegate = self
                        currentCell.configureWithLightingReservation(currentReservation: self.currentBookings[indexPath.row-1])
                    }
                }
            }
        }else{
            if indexPath.row == 0 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingsHeaderCollectioViewCell", for: indexPath) as! BookingsHeaderCollectioViewCell
                if let currentCell = cell as? BookingsHeaderCollectioViewCell{
                    currentCell.configureWithSectiontitle(currentTitle: String.bookings_section_older, isActive: false)
                }
            }else{
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OldBookingsCollectionViewCell", for: indexPath) as! OldBookingsCollectionViewCell
                if let currentCell = cell as? OldBookingsCollectionViewCell{
                    currentCell.configureWithLightingReservation(currentReservation: self.oldBookings[indexPath.row-1],islastBooking: self.oldBookings.count == indexPath.row)
                }
            }
        }
        return cell!
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffsetY = scrollView.contentOffset.y
        var opacity: CGFloat = 1.0
        if scrollOffsetY > -(DevDefines.Metrics.HeaderView.maxSizeBookings/2.0) {
            opacity = 0
        }
        
        if scrollOffsetY > -(DevDefines.Metrics.HeaderView.maxSizeBookings+20) {
            if scrollView == headerViewController.headerView.trackingScrollView {
                headerViewController.headerView.trackingScrollDidScroll()
            }
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


//
// MARK: - CurrentBookingsCollectionViewCellDelegate methods
//

extension BookingViewController: CurrentBookingsCollectionViewCellDelegate {
    
    func cancelAction(currentReservation:AlLightReservation){
        self.showAlert(message: String.bookings_cancel_message, title: String.bookings_cancel_title, buttonCancel: String.generic_cancel, buttonRight: String.generic_accept) { (accept) in
            if accept! {
                self.showCancelOptions(completion: { (reason) in
                    self.bookingsPresenter?.cancelLigintgReservation(reason:reason, currentReservation: currentReservation)
                })
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
    
    func turnOffAction(currentReservation:AlLightReservation){
        self.showAlert(message: String.bookings_turn_off_message, title: String.bookings_turn_off_title, buttonCancel: String.generic_cancel, buttonRight: String.generic_accept) { (accept) in
            if accept! {
                self.showCancelOptions(completion: { (reason) in
                    self.bookingsPresenter?.cancelLigintgReservation(reason:reason, currentReservation: currentReservation)
                })
            }
        }
    }
    
    func extendAction(currentReservation:AlLightReservation){
        self.bookingsPresenter?.checkNeedExtendReservation(currentReservation: currentReservation)
    }
}

//
// MARK: - BookingPresenterDelegate methods
//

extension BookingViewController: BookingPresenterDelegate {
    
    func showExtendRequestDialog(currentReservation:AlLightReservation,currentMinutes: String) {
        self.showAlert(message: String.bookings_extend_message, title: String.bookings_extend_title, buttonCancel: String.generic_cancel, buttonRight: String.bookings_detail_action_extend+" "+currentMinutes) { (accept) in
            if accept! {
                self.bookingsPresenter?.extendReservation(currentReservation: currentReservation)
            }
        }
    }
    

    func showPreErrorRequestDialog(){
        self.showAlert(message: String.bookings_extend_message_error, title: String.bookings_extend_title, buttonCancel: String.generic_cancel, buttonRight: String.generic_accept) { (accept) in
            if accept! {
            }
        }
    }
    
    func showErrorAction(){
        self.collectionView.isHidden = false
        self.collectionView.alpha = 1.0
        self.showAlert(message: String.bookings_generic_error_message, title: String.bookings_generic_error_title, buttonCancel: String.generic_accept, buttonRight: nil) { (accept) in
        }
    }
    
    func configureHeaderView(){
        self.setupHeaderView()
    }
    func configureCollectionView(){
        self.setupCollectionView()
    }
    func showNoResultsView(){
        self.collectionView.isHidden = true
        self.noResultsView.isHidden = false
    }
    func hideNoResultsView(){
        self.collectionView.isHidden = false
        self.noResultsView.isHidden = true
    }
    func showLoadingBookings(){
        self.collectionView.alpha = 0.0
        self.collectionView.isHidden = true
        self.showLoadingView()
    }
    func hideLoadingBookings(completionLoading:@escaping (Bool?) -> Void){
        self.refreshControl.endRefreshing()
        self.hideLoadingView { (completion) in
            completionLoading(completion)
        }
    }
    
    func loadInfoCollectionView(currentBookings:[AlLightReservation], oldBookings:[AlLightReservation]){
        self.currentBookings = currentBookings
        self.oldBookings = oldBookings
        self.collectionView.reloadData()
        if self.loadingByRefresh == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.collectionView.alpha = 1.0
                self.collectionView.animateViews(animations: [AnimationType.from(direction: .bottom, offset: 60.0)], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: 0.30, animationInterval: 0.0, completion: {
                })
            }
        }else{
            self.collectionView.alpha = 1.0
            self.loadingByRefresh = false
        }
        
    }
}
