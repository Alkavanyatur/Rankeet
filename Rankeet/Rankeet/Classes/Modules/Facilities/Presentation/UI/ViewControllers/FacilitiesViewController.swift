//
//  FacilitiesViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18..
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import MapKit
import ViewAnimator

class FacilitiesViewController: RankeetViewController {
    
    @IBOutlet weak var noResultsView: UIView!
    
    @IBOutlet weak var heightViewSearch: NSLayoutConstraint!
    private let kFacilityAnnotationName = "kFacilityAnnotationName"
    
    @IBOutlet weak var backgroundViewColorMap: UIView!
    @IBOutlet weak var backgroundViewColorSearch: UIView!
    
    @IBOutlet weak var viewFilterAppliedIndicator: UIView!
    @IBOutlet weak var buttonSearchMap: UIButton!
    
    @IBOutlet weak var buttonMap: UIButton!
    @IBOutlet weak var buttonFilter: UIButton!
    
    @IBOutlet weak var facilitiesTableView: UITableView!
    @IBOutlet weak var facilitiesMap: MKMapView!
    
    @IBOutlet weak var locationAddressLabel: UILabel!
    
    fileprivate var facilitiesPresenter: FacilitiesPresenter?
    
    fileprivate var prevOffsetYValurToChangeStatus: CGFloat = -100
    
    @IBOutlet weak var noresultsBottomContraints: NSLayoutConstraint!
    
    
    var needToStopTable:Bool = false
    var currentPlace: UserPlace?
    
    var currentFacilities:[Any] = []
    
    static func instantiate() -> FacilitiesViewController{
        let facilitiesStoryBoard = UIStoryboard(name: "Facilities", bundle: nil)
        let facilitiesViewController = facilitiesStoryBoard.instantiateViewController(withIdentifier:"facilitiesViewController") as! FacilitiesViewController
        facilitiesViewController.facilitiesPresenter = FacilitiesPresenter(delegate: facilitiesViewController)
        return facilitiesViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DevDefines.Metrics.isIphoneX {
            self.heightViewSearch.constant = self.heightViewSearch.constant + 20
        }
        NotificationCenter.default.addObserver(self, selector: #selector(applicationBecameActive(notification:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        self.configureView()
        self.facilitiesPresenter?.viewDidAppear()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.facilitiesTableView != nil && (self.facilitiesTableView.contentOffset.y > DevDefines.Metrics.thresholdchangeStatus){
            return .lightContent
        }else{
            return .default
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.facilitiesPresenter?.isAnyFilterEnabled() ?? false {
            self.viewFilterAppliedIndicator.isHidden = false
        }else{
            self.viewFilterAppliedIndicator.isHidden = true
        }
        self.facilitiesTableView.reloadData()
    }
    
    @IBAction func locationAction(_ sender: Any) {
        self.facilitiesPresenter?.changeLocationAction()
    }
    
    @IBAction func addFiltersAction(_ sender: Any) {
        self.facilitiesPresenter?.addFiltersAction()
    }
   
    @IBAction func noLocationMessageAction(_ sender: Any) {
        self.facilitiesPresenter?.requestFromMessageLocation()
    }
    
    @objc func applicationBecameActive(notification: NSNotification){
       self.facilitiesPresenter?.checkBackFromSettings()
    }
    
    @IBAction func mapAction(_ sender: Any) {
        self.facilitiesPresenter?.mapButtonAction(currentOffset:self.facilitiesTableView.contentOffset.y)
    }
    
    @IBAction func mapSearchAction(_ sender: Any) {
        self.hideButtonSearchMap()
        self.facilitiesPresenter?.requestMainFacilitiesWithRegion(currentRegion: self.facilitiesMap.region)
    }
}

//
// MARK: - Configuration View methods
//

extension FacilitiesViewController{
    
    func configureView(){
        self.configureLocationMessageAction(show: false)
        self.configureTableView()
        self.configureMapView()
    }
    
    func configureLocationMessageAction(show:Bool){
        if show {
            if self.currentFacilities.count > 0, let _ = self.currentFacilities[0] as? Int {
                return
            }else{
                self.currentFacilities.insert(-1, at: 0)
            }
        }else{
            if self.currentFacilities.count > 0, let _ = self.currentFacilities[0] as? Int {
                self.currentFacilities.remove(at: 0)
            }
        }
        self.facilitiesTableView.reloadData()
    }
    
    func configureTableView(){
        self.facilitiesTableView.contentInset = UIEdgeInsets(top: DevDefines.Metrics.insetViewMap, left: 0.0, bottom: 0.0, right: 0.0)
        self.facilitiesTableView.rowHeight = UITableViewAutomaticDimension
        self.facilitiesTableView.estimatedRowHeight = 383
        self.facilitiesTableView.register(UINib(nibName: "FacilitiesTableViewCell", bundle: nil), forCellReuseIdentifier: "FacilitiesTableViewCell")
        self.facilitiesTableView.register(UINib(nibName: "MatchTableViewCell", bundle: nil), forCellReuseIdentifier: "MatchTableViewCell")
        self.facilitiesTableView.register(UINib(nibName: "LocationReminderTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationReminderTableViewCell")
        self.facilitiesTableView.dataSource = self
        self.facilitiesTableView.delegate = self
    }
    
    func configureMapView(){
        let mapDragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(gestureRecognizer:)))
        mapDragRecognizer.delegate = self
        self.facilitiesMap.addGestureRecognizer(mapDragRecognizer)
        self.facilitiesMap.delegate = self
    }
    
}

//
// MARK: - Table View methods
//

extension FacilitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currentFacility  = self.currentFacilities[indexPath.row] as? AlFacility, let currentPlace = self.currentPlace{
            self.facilitiesPresenter?.selectFacilityDetail(currentFacility: currentFacility, currentPlace: currentPlace,needTransition: true)
        }else{
            self.facilitiesPresenter?.requestFromMessageLocation()
        }
    }
}

extension FacilitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentFacilities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if let currentFacility  = self.currentFacilities[indexPath.row] as? AlFacility{
            let facilitiesTableViewCell: FacilitiesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FacilitiesTableViewCell", for: indexPath as IndexPath) as! FacilitiesTableViewCell
            facilitiesTableViewCell.contentView.backgroundColor = RankeetDefines.Colors.blueRan
            if let currentLat = self.currentPlace?.coordinate.latitude, let currentLong = self.currentPlace?.coordinate.longitude{
                if indexPath.row == 0 {
                    facilitiesTableViewCell.configureWithFacility(currentFacility: currentFacility,currentLat: currentLat, currentLong:currentLong,isFirstCell:true,needFavouriteAction: true,fromOnboarding: false)
                }else{
                    facilitiesTableViewCell.configureWithFacility(currentFacility: currentFacility,currentLat: currentLat, currentLong:currentLong,isFirstCell:false,needFavouriteAction: true,fromOnboarding: false)
                }
            }
            cell = facilitiesTableViewCell
        }else if let currentValue  = self.currentFacilities[indexPath.row] as? String{
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "MatchTableViewCell", for: indexPath as IndexPath) as! MatchTableViewCell
            currentCell.configureWithValue(currentValue: indexPath.row)
            cell = currentCell
            
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "LocationReminderTableViewCell", for: indexPath as IndexPath) as! LocationReminderTableViewCell
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
}

extension FacilitiesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((self.prevOffsetYValurToChangeStatus < DevDefines.Metrics.thresholdchangeStatus) && (scrollView.contentOffset.y >  DevDefines.Metrics.thresholdchangeStatus)) || ((self.prevOffsetYValurToChangeStatus > DevDefines.Metrics.thresholdchangeStatus) && (scrollView.contentOffset.y <  DevDefines.Metrics.thresholdchangeStatus)){
            self.setNeedsStatusBarAppearanceUpdate()
        }
        self.prevOffsetYValurToChangeStatus = scrollView.contentOffset.y
        
        if (scrollView.contentOffset.y > -80){
            self.backgroundViewColorMap.isHidden = false
            self.backgroundViewColorSearch.alpha = 1.0
        }else{
            self.backgroundViewColorMap.isHidden = true
            self.backgroundViewColorSearch.alpha = 1.0 - ((-80 - scrollView.contentOffset.y)/100.0)
        }
        
        self.facilitiesPresenter?.checkMapButtonState(currentOffset: scrollView.contentOffset.y)
        if self.needToStopTable{
            if scrollView.contentOffset.y < -80 {
                self.needToStopTable = false
                self.configureViewWithList()
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if scrollView.contentOffset.y >= 0 && velocity.y > -2 {
            self.needToStopTable = true
        }else{
            self.needToStopTable = false
        }
    }
}

//
// MARK: - Map methods
//

extension FacilitiesViewController: MKMapViewDelegate,FacilityMapViewDelegate,UIGestureRecognizerDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: kFacilityAnnotationName)
        if annotationView == nil {
            annotationView = AlFacilityPoiAnnotationView(annotation: annotation, reuseIdentifier: kFacilityAnnotationName)
            (annotationView as! AlFacilityPoiAnnotationView).facilityMapViewDelegate = self
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.image = UIImage(named: "icnMapPlaceon")
        if var currentCoordinate = view.annotation?.coordinate{
            currentCoordinate.latitude -= mapView.region.span.latitudeDelta * 0.20;
            mapView.setCenter(currentCoordinate, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named: "ic_place_map")
    }
    
    func detailsRequestedForFacility(facility: AlFacility) {
        if  let currentPlace = self.currentPlace{
            self.facilitiesPresenter?.selectFacilityDetail(currentFacility: facility, currentPlace: currentPlace,needTransition: false)
        }
    }
    
    func moveMapToUserRegion(currentPlace:UserPlace, needAnimation:Bool){
        let center = CLLocationCoordinate2D(latitude: currentPlace.latCoordinate, longitude: currentPlace.longCoordinate)
        let region = MKCoordinateRegionMakeWithDistance(center, CLLocationDistance(RankeetDefines.Location.diameterInitialSearch), CLLocationDistance(RankeetDefines.Location.diameterInitialSearch))
        self.facilitiesMap.setRegion(region, animated: needAnimation)
    }
    
    func configureViewWithMap() {
        self.needToStopTable = false
        self.configureListButton()
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
            self.facilitiesTableView.setContentOffset(CGPoint(x:0,y:-DevDefines.Metrics.insetViewMap), animated: false)
        }) { _ in
        }
    }
    
    func configureViewWithList(){
        self.needToStopTable = false
        self.hideButtonSearchMap()
        if let place = self.currentPlace{
            self.moveMapToUserRegion(currentPlace: place, needAnimation: true)
        }
        self.configureMapButton()
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
            self.facilitiesTableView.setContentOffset(CGPoint(x:0,y:0), animated: false)
        }) { _ in
        }
    }
    
    func showFacilitiesInMap(){
        self.facilitiesMap.removeAnnotations(facilitiesMap.annotations)
        for facility in self.currentFacilities {
            if let currentFacility  = facility as? AlFacility{
                if let place = self.currentPlace{
                    let pin = AlFacilityPoiAnnotation(facility: currentFacility, userPlace: place)
                    self.facilitiesMap.addAnnotation(pin)
                }
            }
        }
    }
    
    func showButtonSearchMap(){
        if self.buttonSearchMap.isHidden  {
            self.buttonSearchMap.isHidden = false
            UIView.animate(withDuration: DevDefines.Animations.quickAnimationTime, animations: {
                self.buttonSearchMap.alpha = 1.0
            })
        }
    }
    
    func hideButtonSearchMap(){
        UIView.animate(withDuration: DevDefines.Animations.quickAnimationTime, animations: {
            self.buttonSearchMap.alpha = 0.0
        }) { (completion) in
            self.buttonSearchMap.isHidden = true
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func didDragMap(gestureRecognizer: UIGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerState.began) {
            for currentAnnotation in self.facilitiesMap.annotations {
                self.facilitiesMap.deselectAnnotation(currentAnnotation, animated: true)
            }
        }else if (gestureRecognizer.state == UIGestureRecognizerState.ended) {
            self.showButtonSearchMap()
        }
    }
}

//
// MARK: - FacilitiesPresenterDelegate methods
//

extension FacilitiesViewController: FacilitiesPresenterDelegate {
    
    func configureMapButton(){
        self.buttonMap.setImage(UIImage(named:"icnHomeMap"), for: .normal)
    }
    
    func configureListButton(){
        self.buttonMap.setImage(UIImage(named:"icnHomeList"), for: .normal)
    }
    
    func showMapMode() {
        self.configureViewWithMap()
    }
    
    func hideMapMode() {
        self.configureViewWithList()
    }
    
    func configureWithPlace(currentPlace:UserPlace, needAnimation:Bool, currentState:RankeetLocationResponseType){
        self.currentPlace = currentPlace
        self.locationAddressLabel.text = currentPlace.address
        
        self.moveMapToUserRegion(currentPlace:currentPlace , needAnimation: needAnimation)
        self.facilitiesPresenter?.requestMainFacilitiesWithPlace(currentPlace: currentPlace)
        
        switch currentState {
        case .errorRetrieve:
            self.showAlert(message:String.facilities_error_location_dialog_message , title: String.facilities_error_location_dialog_title, buttonCancel: String.generic_accept, buttonRight: nil, completion: { (accept) in
            })
            break
        case .farAwayFromCenter:
            self.showAlert(message:String.facilities_error_location_dialog_message , title: String.facilities_farway_dialog_title, buttonCancel: String.generic_accept, buttonRight: nil, completion: { (accept) in
            })
            break
        default:
            break
        }
    }
    
    func configureWithFacility(currentFacility:AlFacility, needAnimation:Bool){
        if let currentPlace = self.currentPlace{
            self.facilitiesPresenter?.selectFacilityDetail(currentFacility: currentFacility, currentPlace: currentPlace,needTransition: false)
        }
    }
    
    func configureWithPlaceFromMap(currentPlace:UserPlace){
        self.currentPlace = currentPlace
        self.locationAddressLabel.text = currentPlace.address
    }
    
    func requestPermissionLocation(){
        self.showAlert(message: String.facilities_message_location_message, title: String.facilities_message_location_title, buttonCancel: String.facilities_message_location_button_later, buttonRight: String.facilities_message_location_button_yes) { (buttonYes) in
            if let currentResult = buttonYes, currentResult == true{
                self.facilitiesPresenter?.requestLocation()
            }else{
                self.facilitiesPresenter?.noLocationResponse()
            }
        }
    }
    func responseWithNoLocationEnabled(show:Bool){
        self.configureLocationMessageAction(show: show)
    }
    
    func showLoadingFacilities() {
        self.showLoadingView()
    }
    
    func hideLoadingFacilities(completionLoading: @escaping (Bool?) -> Void) {
        self.hideLoadingView(completionLoading: completionLoading)
    }
    
    func showMessageNoFacilitiesInfoError(){
        self.showAlert(message: String.facilities_error_message, title: String.generic_error, buttonCancel: String.generic_accept, buttonRight: nil) { (accept) in
        }
    }
    
    func loadFacilities(facilities:[AlFacility]){
        if self.currentFacilities.count > 0, let _ = self.currentFacilities[0] as? Int {
            self.currentFacilities = facilities
            self.currentFacilities.insert(-1, at: 0)
        }else{
            self.currentFacilities = facilities
        }
        
        if self.currentFacilities.count > 1 {
            self.currentFacilities.insert("match", at: 1)
        }
        if self.currentFacilities.count > 3 {
            self.currentFacilities.insert("match", at: 3)
        }
        if self.currentFacilities.count > 5 {
            self.currentFacilities.insert("match", at: 5)
        }
        
        if self.currentFacilities.count == 0 {
            self.showNoResultsView()
        }else{
            self.hideNoResultsView()
        }
        
        self.facilitiesTableView.reloadData()
        self.facilitiesTableView.animateViews(animations: [AnimationType.from(direction: .bottom, offset: 30.0)], completion: {
        })
        self.showFacilitiesInMap()
    }
    
    func showNoResultsView(){
        self.noResultsView.animate(animations: [AnimationType.from(direction: .bottom, offset: 100.0)], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: {
        })
    }
    
    func hideNoResultsView(){
        self.noResultsView.animate(animations: [AnimationType.from(direction: .top, offset: -100.0)], reversed: false, initialAlpha: 1.0, finalAlpha: 0.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: {
        })
    }
}
