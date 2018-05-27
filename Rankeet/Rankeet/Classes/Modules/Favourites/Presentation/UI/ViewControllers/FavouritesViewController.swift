//
//  FavouritesViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ViewAnimator
import MaterialComponents.MaterialFlexibleHeader


protocol FavouritesViewControllerDelegate: NSObjectProtocol {
    func needToUpdateStatusBar(needLight:Bool)
}

class FavouritesViewController: RankeetViewController {

    @IBOutlet weak var facilitiesTableView: UITableView!
    var headerViewController: MDCFlexibleHeaderViewController!
    fileprivate var headerContentView:FavouritesHeaderView!
    
    @IBOutlet weak var noResultsView: UIView!
    weak var delegate: FavouritesViewControllerDelegate?

    fileprivate var favouritesPresenter: FavouritesPresenter?
    fileprivate var prevOpacity:CGFloat = 1.0
    
    fileprivate var currentFacilities: [AlFacility] = []
    fileprivate var userPlace: UserPlace?
    
    
    static func instantiate() -> FavouritesViewController{
        let favouritesStoryBoard = UIStoryboard(name: "Favourites", bundle: nil)
        let favouritesViewController = favouritesStoryBoard.instantiateViewController(withIdentifier:"favouritesViewController") as! FavouritesViewController
        favouritesViewController.favouritesPresenter = FavouritesPresenter(delegate: favouritesViewController)
        return favouritesViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favouritesPresenter?.viewDidAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sizeHeaderView()
        self.favouritesPresenter?.viewWillAppear()
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
        if let views = Bundle.main.loadNibNamed("FavouritesHeaderView", owner: self, options: nil) as? [FavouritesHeaderView], views.count > 0, let currentView = views.first{
            self.headerContentView = currentView
        }
    }
}


//
// MARK: - Configuration View methods
//

extension FavouritesViewController{
    
    func configureViewLoad(){
        self.configureTableView()
        self.setupHeaderView()
        
        self.userPlace = LocationManager().getDefaultUserPlace()
        if let currentLocation = LocationManager().requestCurrentPlace() {
            self.userPlace = currentLocation
        }
    }
    
    func configureTableView(){
        self.facilitiesTableView.rowHeight = UITableViewAutomaticDimension
        self.facilitiesTableView.estimatedRowHeight = 383
        self.facilitiesTableView.register(UINib(nibName: "FacilitiesTableViewCell", bundle: nil), forCellReuseIdentifier: "FacilitiesTableViewCell")
        self.facilitiesTableView.dataSource = self
        self.facilitiesTableView.delegate = self
    }
}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.favouritesPresenter?.selectFacilityFromUser(currentFacility: self.currentFacilities[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentFacilities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FacilitiesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FacilitiesTableViewCell", for: indexPath as IndexPath) as! FacilitiesTableViewCell
        cell.configureWithFacility(currentFacility: self.currentFacilities[indexPath.row],currentLat: self.userPlace?.coordinate.latitude, currentLong:self.userPlace?.coordinate.longitude, isFirstCell: false,needFavouriteAction: true,fromOnboarding: false)
        cell.delegate = self
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

extension FavouritesViewController: FacilitiesTableViewCellDelegate{
    func toggleBookmarkFacility() {
        self.favouritesPresenter?.requestFavourites()
    }
}



//
// MARK: - FavouritesViewController methods
//

extension FavouritesViewController: FavouritesPresenterDelegate {
    
    func configureView(){
        self.configureViewLoad()
    }
    
    func showNoResultsView(){
        self.facilitiesTableView.isHidden = true
        self.noResultsView.isHidden = false
    }
    func hideNoResultsView(){
        self.facilitiesTableView.isHidden = false
        self.noResultsView.isHidden = true
    }
    func showLoadingFacilities(){
        self.facilitiesTableView.alpha = 0.0
        self.facilitiesTableView.isHidden = true
        self.showLoadingView()
    }
    func hideLoadingFacilities(completionLoading:@escaping (Bool?) -> Void){
        self.hideLoadingView { (completion) in
            completionLoading(completion)
        }
    }
    
    func loadInfoTableView(currentFacilities:[AlFacility]){
        self.currentFacilities = currentFacilities
        self.facilitiesTableView.alpha = 1.0
        self.facilitiesTableView.reloadData()
        self.facilitiesTableView.animateViews(animations: [AnimationType.from(direction: .bottom, offset: 60.0)], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: 0.30, animationInterval: 0.0, completion: {
        })
    }
}
