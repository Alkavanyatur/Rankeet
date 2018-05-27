//
//  OnboardingSelectFacilityViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ViewAnimator
import MaterialComponents.MaterialFlexibleHeader

protocol OnboardingSelectFacilityViewControllerDelegate: NSObjectProtocol {
    func needToUpdateStatusBar(needLight:Bool)
    func selectFacilityFromUser(currentFacility: AlFacility)
}

class OnboardingSelectFacilityViewController: RankeetViewController {
    
    @IBOutlet weak var facilitiesTableView: UITableView!
    var headerViewController: MDCFlexibleHeaderViewController!
    fileprivate var headerContentView:OnboardingSelectFacilityHeaderView!
    
    fileprivate var prevOpacity:CGFloat = 1.0
    
    weak var delegate: OnboardingSelectFacilityViewControllerDelegate?
    
    var currentFacilities:[AlFacility] = []
    fileprivate var onboardingSelectFacilityPresenter: OnboardingSelectFacilityPresenter?
    
    static func instantiate() -> OnboardingSelectFacilityViewController{
        let OnboardingStoryBoard = UIStoryboard(name: "Onboarding", bundle: nil)
        let onboardingSelectFacilityViewController = OnboardingStoryBoard.instantiateViewController(withIdentifier:"onboardingSelectFacilityViewController") as! OnboardingSelectFacilityViewController
        onboardingSelectFacilityViewController.onboardingSelectFacilityPresenter = OnboardingSelectFacilityPresenter(delegate: onboardingSelectFacilityViewController)
        return onboardingSelectFacilityViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onboardingSelectFacilityPresenter?.viewDidload()
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sizeHeaderView()
    }
    
    // Public button methods
    @IBAction func dismissView(_ sender: Any) {
        self.onboardingSelectFacilityPresenter?.dismissFromUser()
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
        headerView.trackingScrollView = self.facilitiesTableView
        headerView.maximumHeight = DevDefines.Metrics.HeaderView.maxSizeBookings
        headerView.minimumHeight = DevDefines.Metrics.HeaderView.minSizeBookings
        headerView.minMaxHeightIncludesSafeArea = false
        headerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerContentView.frame = (headerView.bounds)
        headerContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerView.addSubview(headerContentView)
    }
    func loadHeaderView() {
        if let views = Bundle.main.loadNibNamed("OnboardingSelectFacilityHeaderView", owner: self, options: nil) as? [OnboardingSelectFacilityHeaderView], views.count > 0, let currentView = views.first{
            currentView.delegate = self
            self.headerContentView = currentView
        }
    }
}

//
// MARK: - Configuration View methods
//

extension OnboardingSelectFacilityViewController{
    
    func configureView(){
        self.configureTableView()
    }
    
    func configureTableView(){
        self.facilitiesTableView.rowHeight = UITableViewAutomaticDimension
        self.facilitiesTableView.estimatedRowHeight = 383
        self.facilitiesTableView.register(UINib(nibName: "FacilitiesTableViewCell", bundle: nil), forCellReuseIdentifier: "FacilitiesTableViewCell")
        self.facilitiesTableView.dataSource = self
        self.facilitiesTableView.delegate = self
    }
}

extension OnboardingSelectFacilityViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectFacilityFromUser(currentFacility: self.currentFacilities[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentFacilities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FacilitiesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FacilitiesTableViewCell", for: indexPath as IndexPath) as! FacilitiesTableViewCell
        cell.configureWithFacility(currentFacility: self.currentFacilities[indexPath.row],currentLat: nil, currentLong:nil, isFirstCell: false,needFavouriteAction: false,fromOnboarding: true)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == headerViewController.headerView.trackingScrollView {
            headerViewController.headerView.trackingScrollDidScroll()
        }
        let scrollOffsetY = scrollView.contentOffset.y
        var opacity: CGFloat = 1.0
        if scrollOffsetY > -(DevDefines.Metrics.HeaderView.maxSizeBookings/2.0) {
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

extension OnboardingSelectFacilityViewController:OnboardingSelectFacilityPresenterDelegate{
    
    func showLoadingFacilities() {
        self.showLoadingView()
    }
    func configureHeaderView(){
        self.setupHeaderView()
    }
    func hideLoadingFacilities(completionLoading: @escaping (Bool?) -> Void) {
        self.hideLoadingView(completionLoading: completionLoading)
    }
    func showMessageNoFacilitiesInfoError(){
        self.showAlert(message: String.facilities_error_message, title: String.generic_error, buttonCancel: String.generic_accept, buttonRight: nil) { (accept) in
            self.onboardingSelectFacilityPresenter?.dismissFromUser()
        }
    }
    func loadFacilities(facilities:[AlFacility]){
        self.currentFacilities = facilities
        self.facilitiesTableView.reloadData()
        self.facilitiesTableView.animateViews(animations: [AnimationType.from(direction: .bottom, offset: 60.0)], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: 0.30, animationInterval: 0.0, completion: {
        })
    }
}

extension OnboardingSelectFacilityViewController: OnboardingSelectFacilityHeaderViewDelegate {
    func backFromDetailHeader() {
        self.dismissView(self)
    }
    


}
