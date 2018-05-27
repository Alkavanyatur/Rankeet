//
//  FacilityDetailViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 27/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreLocation
import PopupDialog
import MaterialComponents.MaterialFlexibleHeader
import NVActivityIndicatorView
import Hero

protocol FacilityDetailViewControllerDelegate: NSObjectProtocol {
    func needToUpdateStatusBar(needLight:Bool)
}

class FacilityDetailViewController: RankeetViewController {

    weak var delegate: FacilityDetailViewControllerDelegate?
    
    @IBOutlet weak var labelTitleCreate: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    var headerViewController: MDCFlexibleHeaderViewController!
    
    @IBOutlet weak var lightingView: UIView!
    @IBOutlet weak var lightingViewImage: UIImageView!
    @IBOutlet weak var lightingViewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adressButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var labelDistrict: UILabel!
    
    @IBOutlet weak var viewTrain: UIView!
    @IBOutlet weak var heightTrain: NSLayoutConstraint!
    @IBOutlet weak var labelTrain: UILabel!
    
    @IBOutlet weak var viewSubway: UIView!
    @IBOutlet weak var heightSubway: NSLayoutConstraint!
    @IBOutlet weak var labelsubway: UILabel!
    
    @IBOutlet weak var viewBus: UIView!
    @IBOutlet weak var heightBus: NSLayoutConstraint!
    @IBOutlet weak var labelBus: UILabel!
    
    @IBOutlet weak var labelDescription: UILabel!
    
    @IBOutlet weak var stackSports: UIStackView!
    
    @IBOutlet weak var viewTitleStart: UIView!
    @IBOutlet weak var scrollStart: UIScrollView!
    @IBOutlet weak var stackStartHours: UIStackView!
    @IBOutlet weak var viewTitleEnds: UIView!
    @IBOutlet weak var scrollEnds: UIScrollView!
    @IBOutlet weak var stackEndHours: UIStackView!
    
    fileprivate var endHours:[Date] = []
    fileprivate var startHours:[Date] = []
    fileprivate var formatterHour = DateFormatter()
    fileprivate var selectionHour:Bool = false
    
    @IBOutlet weak var viewTitleFields: UILabel!
    @IBOutlet weak var stackFields: UIStackView!
    
    @IBOutlet weak var fieldsToTitleConstraints: NSLayoutConstraint!
    @IBOutlet weak var fieldsToDescriptionConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var buttonSeeFields: UIButton!
    
    @IBOutlet weak var selectionHourLabel: UILabel!
    @IBOutlet weak var viewLoadingDetail: UIView!
    @IBOutlet weak var viewLoadingDetailStartHour: UIView!
    @IBOutlet weak var viewLoadingDetailEndHour: UIView!
    
    @IBOutlet weak var buttonSwithOn: UIButton!
    
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var activityIndicatorStart: NVActivityIndicatorView!
    @IBOutlet weak var activityIndicatorEnd: NVActivityIndicatorView!
    
    @IBOutlet weak var viewSportSelection: UIView!
    @IBOutlet weak var buttonSportSelection: UIButton!
    
    fileprivate var headerContentView:FacilityDetailHeaderView!
    fileprivate var prevOpacity:CGFloat = 1.0
    fileprivate var facilityDetailPresenter: FacilityDetailPresenter?
    
    @IBOutlet weak var heightNearFacilities: NSLayoutConstraint!
    
    fileprivate var fromOnboarding:Bool = false
    
    static func instantiate(currentFacility:AlFacility,currentPlace:UserPlace,fromOnboarding:Bool) -> FacilityDetailViewController{
        let facilitiesStoryBoard = UIStoryboard(name: "Facilities", bundle: nil)
        let facilityDetailViewController = facilitiesStoryBoard.instantiateViewController(withIdentifier:"facilityDetailViewController") as! FacilityDetailViewController
        facilityDetailViewController.fromOnboarding = fromOnboarding
        facilityDetailViewController.facilityDetailPresenter = FacilityDetailPresenter(delegate:facilityDetailViewController,currentFacility:currentFacility,currentPlace:currentPlace)
        facilityDetailViewController.formatterHour.timeZone = TimeZone.current
        facilityDetailViewController.formatterHour.dateFormat = "HH:mm"
        return facilityDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.fromOnboarding {
            self.heightNearFacilities.constant = 0.0
        }
        self.facilityDetailPresenter?.viewDidAppear(fromOnboarding: self.fromOnboarding)
        self.buttonSportSelection.setTitle("   "+String.facility_sport_selection_any_sport, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sizeHeaderView()
    }
    
    @IBAction func reservationAction(_ sender: Any) {
        self.facilityDetailPresenter?.createReservationAction()
    }
    
    @IBAction func addressAction(_ sender: Any) {
        self.facilityDetailPresenter?.addressActionMethod()
    }
    
    @IBAction func selectSportAction(_ sender: Any) {
        self.facilityDetailPresenter?.selectSportAction()
    }
    
    //
    // MARK: - Header methods
    //
    
    func sizeHeaderView() {
        let headerView = headerViewController.headerView
        let bounds = UIScreen.main.bounds
        if bounds.size.width < bounds.size.height {
            if self.fromOnboarding {
                headerView.maximumHeight = DevDefines.Metrics.HeaderView.maxSizeOnboarding
            }else{
                headerView.maximumHeight = DevDefines.Metrics.HeaderView.maxSize
            }
        } else {
            headerView.maximumHeight = DevDefines.Metrics.HeaderView.minSize
        }
        headerView.minimumHeight = DevDefines.Metrics.HeaderView.minSize
    }
    func setupHeaderView(currentFacility:AlFacility) {
        self.loadHeaderView(currentFacility: currentFacility)
        
        let headerView = headerViewController.headerView
        headerView.trackingScrollView = self.scrollview
        if self.fromOnboarding {
            headerView.maximumHeight = DevDefines.Metrics.HeaderView.maxSizeOnboarding
        }else{
            headerView.maximumHeight = DevDefines.Metrics.HeaderView.maxSize
        }
        headerView.minimumHeight = DevDefines.Metrics.HeaderView.minSize
        headerView.minMaxHeightIncludesSafeArea = false
        headerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerContentView.frame = (headerView.bounds)
        headerContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerView.addSubview(headerContentView)
    }
    func loadHeaderView(currentFacility:AlFacility) {
        if let views = Bundle.main.loadNibNamed("FacilityDetailHeaderView", owner: self, options: nil) as? [FacilityDetailHeaderView], views.count > 0, let currentView = views.first{
            self.headerContentView = currentView
            self.headerContentView.delegate = self
            self.headerContentView.configureWithFacility(currentFacility: currentFacility,fromOnboarding: self.fromOnboarding)
        }
    }
    
    //
    // MARK: - Body methods
    //
    func setupBodyView(currentFacility:AlFacility, currentLat:Double?, currentLong:Double?){
        self.configureMainInformation(currentFacility: currentFacility,currentLat:currentLat,currentLong:currentLong)
    }
    
    func configureMainInformation(currentFacility:AlFacility,currentLat:Double?, currentLong:Double?){
        
        let num:Int = Int(arc4random_uniform(10))
        if num > 5 {
            self.lightingViewLabel.text = "HAY UN PARTIDO EN JUEGO!"
            self.lightingViewImage.image = UIImage(named:"ball")
        }else{
            self.lightingViewLabel.text = "NO HAY PARTIDOS"
            self.lightingViewImage.image = nil
        }
        
        if let currentLat = currentLat, let currentLong = currentLong{
            let coordinate₀ = CLLocation(latitude: Double(currentFacility.latitude), longitude: Double(currentFacility.longitude))
            let coordinate₁ = CLLocation(latitude: currentLat, longitude: currentLong)
            let distanceInMeters = coordinate₀.distance(from: coordinate₁)
            
            if distanceInMeters < 1000 {
                self.distanceLabel.text = String.facility_cell_distance_prefix + " \(Int(distanceInMeters)) m"
            }else{
                self.distanceLabel.text = String.facility_cell_distance_prefix + " \(Int(distanceInMeters/1000)) km"
            }
        }else{
            self.distanceLabel.text = ""
        }
        
        if let currentAdress = currentFacility.info?.address {
            self.adressButton.semanticContentAttribute = .forceRightToLeft
            self.adressButton.setTitle(currentAdress+"  ", for: .normal)
        }else{
            self.adressButton.isHidden = true
        }
        
        if let currentTrain = currentFacility.info?.train, currentTrain.count > 0 {
            self.labelTrain.text = currentTrain
        }else{
            self.viewTrain.alpha = 0.0
            self.heightTrain.constant = 0.0
        }
        if let currentSubway = currentFacility.info?.subway, currentSubway.count > 0 {
            self.labelsubway.text = currentSubway
        }else{
            self.viewSubway.alpha = 0.0
            self.heightSubway.constant = 0.0
        }
        if let currentBus = currentFacility.info?.bus, currentBus.count > 0 {
            self.labelBus.text = currentBus
        }else{
            self.viewBus.alpha = 0.0
            self.heightBus.constant = 0.0
        }
        
        if let currentNeiborhood = currentFacility.info?.neighborhood, currentNeiborhood.count > 0 {
            if let currentDistrict = currentFacility.info?.district, currentDistrict.count > 0 {
                self.labelDistrict.text = currentNeiborhood + " (\(currentDistrict))"
            }else{
                self.labelDistrict.text = currentNeiborhood
            }
        }else if let currentDistrict = currentFacility.info?.district, currentDistrict.count > 0 {
            self.labelDistrict.text = currentDistrict
        }
        
        self.buttonSeeFields.setTitle(String.facility_detail_select_see_map+"  ", for: .normal)
        self.buttonSeeFields.setImage(UIImage(named:"icnArrowSeefields"), for: .normal)
        self.buttonSeeFields.semanticContentAttribute = .forceRightToLeft
        
        self.titleLabel.heroID = (currentFacility.idFacility)+"_name"
        self.titleLabel.text = currentFacility.nameFacility
        
        self.labelDescription.text = currentFacility.info?.infoLoc ?? ""
    }
    
    func configureSportsInformation(currentSports:[Int]){
        let paddingViewStart = UIView(frame: CGRect(x: 0, y: 0, width: 10.0, height: 0.0))
        paddingViewStart.widthAnchor.constraint(equalToConstant: 10).isActive = true
        self.stackSports.addArrangedSubview(paddingViewStart)
        for currentSport in currentSports {
            if let nameSport = self.facilityDetailPresenter?.getNameSportByType(currentType: currentSport){
                let currentButton:UIButton = UIButton()
                currentButton.backgroundColor = RankeetDefines.Colors.greyWhite
                currentButton.setTitleColor(RankeetDefines.Colors.greyish, for: .normal)
                currentButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                currentButton.cornerRadius = 13.5
                currentButton.setTitle("   "+nameSport+"    ", for: .normal)
                self.stackSports.addArrangedSubview(currentButton)
            }
        }
        let paddingViewEnd = UIView(frame: CGRect(x: 0, y: 0, width: 10.0, height: 0.0))
        paddingViewEnd.widthAnchor.constraint(equalToConstant: 10).isActive = true
        self.stackSports.addArrangedSubview(paddingViewEnd)
    }
    
    func configureStartHoursBooking(currentHours:[Date],needNowTime:Bool){
        self.startHours = currentHours
        for currentView in self.stackStartHours.arrangedSubviews{
            currentView.removeFromSuperview()
        }
        let paddingViewStart = UIView(frame: CGRect(x: 0, y: 0, width: 10.0, height: 0.0))
        paddingViewStart.widthAnchor.constraint(equalToConstant: 10).isActive = true
        self.stackStartHours.addArrangedSubview(paddingViewStart)
        var currentIndexHour:Int = 0
        for currentHour in currentHours {
            if currentIndexHour == 0 && needNowTime == true {
                let currentButton:UIButton = UIButton()
                self.configureButtonWithNoSelectionStyle(currentButton: currentButton)
                currentButton.tag = -1
                currentButton.setTitle("     "+String.facility_detail_now+"     ", for: .normal)
                currentButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
                currentButton.addTarget(self, action: #selector(selectStartHourAction(_:)), for:.touchUpInside)
                self.stackStartHours.addArrangedSubview(currentButton)
            }
            let currentButton:UIButton = UIButton()
            self.configureButtonWithNoSelectionStyle(currentButton: currentButton)
            currentButton.tag = currentIndexHour
            let currentHourName = self.formatterHour.string(from: currentHour)
            currentButton.setTitle("     "+currentHourName+"     ", for: .normal)
            currentButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
            currentButton.addTarget(self, action: #selector(selectStartHourAction(_:)), for:.touchUpInside)
            self.stackStartHours.addArrangedSubview(currentButton)
            currentIndexHour = currentIndexHour + 1
        }
        let paddingViewEnd = UIView(frame: CGRect(x: 0, y: 0, width: 10.0, height: 0.0))
        paddingViewEnd.widthAnchor.constraint(equalToConstant: 10).isActive = true
        self.stackStartHours.addArrangedSubview(paddingViewEnd)
    }
    
    func configureButtonWithNoSelectionStyle(currentButton:UIButton){
        currentButton.layer.cornerRadius = 8.0
        currentButton.layer.borderWidth = 1
        currentButton.setTitleColor(RankeetDefines.Colors.aquaBlue, for: .normal)
        currentButton.layer.borderColor = RankeetDefines.Colors.aquaBlue.cgColor
        currentButton.backgroundColor = UIColor.clear
    }
    
    func configureButtonWithSelectionStyle(currentButton:UIButton){
        currentButton.layer.cornerRadius = 8.0
        currentButton.layer.borderWidth = 0
        currentButton.backgroundColor = RankeetDefines.Colors.aquaBlue
        currentButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func configureButtonWithNoAvailableStyle(currentButton:UIButton){
        currentButton.layer.cornerRadius = 8.0
        currentButton.layer.borderWidth = 1
        currentButton.backgroundColor = UIColor.clear
        currentButton.layer.borderColor = RankeetDefines.Colors.pinkishGrey.cgColor
        currentButton.setTitleColor(RankeetDefines.Colors.pinkishGrey, for: .normal)
    }
    
    func configureEndHoursBooking(currentHours:[Date]){
        self.endHours = currentHours
        for currentView in self.stackEndHours.arrangedSubviews{
            currentView.removeFromSuperview()
        }
        let paddingViewStart = UIView(frame: CGRect(x: 0, y: 0, width: 10.0, height: 0.0))
        paddingViewStart.widthAnchor.constraint(equalToConstant: 10).isActive = true
        self.stackEndHours.addArrangedSubview(paddingViewStart)
        var currentIndexHour:Int = 0
        for currentHour in currentHours {
            let currentButton:UIButton = UIButton()
            if self.selectionHour {
                self.configureButtonWithNoSelectionStyle(currentButton: currentButton)
            }else{
                self.configureButtonWithNoAvailableStyle(currentButton: currentButton)
            }
            currentButton.tag = currentIndexHour
            currentButton.setTitle("     "+(self.formatterHour.string(from: currentHour))+"     ", for: .normal)
            currentButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
            currentButton.addTarget(self, action: #selector(selectEndHourAction(_:)), for:.touchUpInside)
            self.stackEndHours.addArrangedSubview(currentButton)
            currentIndexHour = currentIndexHour + 1
        }
        let paddingViewEnd = UIView(frame: CGRect(x: 0, y: 0, width: 10.0, height: 0.0))
        paddingViewEnd.widthAnchor.constraint(equalToConstant: 10).isActive = true
        self.stackEndHours.addArrangedSubview(paddingViewEnd)
    }
    
    func checkResumLabel(){
        self.buttonSwithOn.setTitle(self.facilityDetailPresenter?.requestCurrentStateSwitchOnLabel(), for: .normal)
        self.selectionHourLabel.text = self.facilityDetailPresenter?.requestCurrentStateResumeLabel()
        if let result = self.facilityDetailPresenter?.enableSwithOnButton(), result == true {
            UIView.animate(withDuration: DevDefines.Animations.quickAnimationTime, animations: {
                self.buttonSwithOn.setTitleColor(UIColor.white, for: .normal)
            })
        }else{
            self.buttonSwithOn.setTitleColor(RankeetDefines.Colors.whiteAlpha, for: .normal)
        }
    }

    //
    // MARK: - Action methods
    //
    @objc func selectStartHourAction(_ sender: Any) {
        for currentView in self.stackStartHours.arrangedSubviews {
            if let currentButton:UIButton = currentView as? UIButton {
                self.configureButtonWithNoSelectionStyle(currentButton: currentButton)
            }
        }
        if let currentButton:UIButton = sender as? UIButton {
            self.configureButtonWithSelectionStyle(currentButton: currentButton)
            self.selectionHour = true
            if self.startHours.count > currentButton.tag {
                UIView.animate(withDuration: DevDefines.Animations.quickAnimationTime, animations: {
                    self.stackEndHours.alpha = 1.0
                })
                self.facilityDetailPresenter?.deSelectField()
                if currentButton.tag == -1 {
                    self.facilityDetailPresenter?.selectStartHour(currentHour:Date())
                }else{
                    self.facilityDetailPresenter?.selectStartHour(currentHour:self.startHours[currentButton.tag])
                }
                self.checkResumLabel()
            }
        }
    }
    
    @objc func selectEndHourAction(_ sender: Any) {
        guard self.selectionHour else {
            return
        }
        for currentView in self.stackEndHours.arrangedSubviews {
            if let currentButton:UIButton = currentView as? UIButton {
                self.configureButtonWithNoSelectionStyle(currentButton: currentButton)
            }
        }
        if let currentButton:UIButton = sender as? UIButton {
            self.configureButtonWithSelectionStyle(currentButton: currentButton)
            if self.endHours.count > currentButton.tag {
                self.facilityDetailPresenter?.deSelectField()
                self.facilityDetailPresenter?.selectEndHour(currentHour:self.endHours[currentButton.tag])
                self.checkResumLabel()
            }
        }
    }
}

extension FacilityDetailViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerViewController.scrollViewDidScroll(scrollView)
        let scrollOffsetY = scrollView.contentOffset.y
        var opacity: CGFloat = 1.0
        if self.fromOnboarding {
            if scrollOffsetY > -(DevDefines.Metrics.HeaderView.maxSizeOnboarding/2.0) {
                opacity = 0
            }
        }else{
            if scrollOffsetY > -(DevDefines.Metrics.HeaderView.maxSize/2.0) {
                opacity = 0
            }
        }
        if self.headerContentView != nil {
            self.headerContentView.opacityAction(currentOpacity: opacity)
            if self.prevOpacity != opacity {
                if self.prevOpacity > opacity {
                    self.delegate?.needToUpdateStatusBar(needLight: true)
                }else{
                    if self.fromOnboarding {
                        self.delegate?.needToUpdateStatusBar(needLight: false)
                    }else{
                        self.delegate?.needToUpdateStatusBar(needLight: true)
                    }
                }
                self.prevOpacity = opacity
            }
        }
    }
}

extension FacilityDetailViewController: FacilityDetailHeaderViewDeleagte{
    func backFromDetailHeader(){
        self.facilityDetailPresenter?.backFromDetail()
    }
    func hideFromDetailHeader(){
        self.facilityDetailPresenter?.hideFromDetail()
    }
}

extension FacilityDetailViewController: FacilityDetailPresenterDelegate{
    
    func configureWithSportName(currentName:String){
        self.selectionHour = false
        self.buttonSportSelection.setTitle("    "+currentName, for: .normal)
    }

    func questionNavigate(currentName:String, currentAddressLat:Float, currentAddressLong:Float){
        let popup = PopupDialog(title: String.facility_route_question_title, message: String.facility_route_question_message)
        // This button will not the dismiss the dialog
        let buttonGoogle = DefaultButton(title: String.facility_route_question_first_button, dismissOnTap: true) {
            self.facilityDetailPresenter?.googleMapsAction(currentLat: currentAddressLat, currentLong: currentAddressLong)
        }
        let buttonApple = DefaultButton(title: String.facility_route_question_second_button, dismissOnTap: true) {
            self.facilityDetailPresenter?.appleMapsAction(currentName:currentName,currentLat:currentAddressLat, currentLong:currentAddressLong)
        }
        popup.addButtons([buttonGoogle, buttonApple])
        self.present(popup, animated: true, completion: nil)
    }

    func showloadingFacilityDetail() {
        self.buttonSportSelection.alpha = 0.5
        self.buttonSportSelection.isEnabled = false
        self.activityIndicatorView.startAnimating()
        self.activityIndicatorStart.startAnimating()
        self.activityIndicatorEnd.startAnimating()
        UIView.animate(withDuration: DevDefines.Animations.quickAnimationTime, animations: {
            self.viewLoadingDetailStartHour.alpha = 1.0
            self.viewLoadingDetailEndHour.alpha = 1.0
            self.viewLoadingDetail.alpha = 1.0
            self.selectionHourLabel.alpha = 0.0
        }) { (completion) in
        }
    }
    
    func hideLoadingFacilityDetail() {
        self.buttonSportSelection.isEnabled = true
        UIView.animate(withDuration: DevDefines.Animations.quickAnimationTime, animations: {
            self.buttonSportSelection.alpha = 1.0
            self.viewLoadingDetailStartHour.alpha = 0.0
            self.viewLoadingDetailEndHour.alpha = 0.0
            self.viewLoadingDetail.alpha = 0.0
            self.selectionHourLabel.alpha = 1.0
        }) { (completion) in
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorStart.stopAnimating()
            self.activityIndicatorEnd.stopAnimating()
        }
    }
    
    func needExtraInfoRankeetSystem(needInfo:Bool){
        if needInfo == false {
            self.viewTitleStart.isHidden = true
            self.scrollStart.isHidden = true
            self.viewTitleEnds.isHidden = true
            self.scrollEnds.isHidden = true
            self.viewTitleFields.isHidden = true
            self.viewSportSelection.isHidden = true
            self.labelTitleCreate.isHidden = true
            
            self.fieldsToDescriptionConstraints.priority = UILayoutPriority(rawValue: 1000)
            self.fieldsToTitleConstraints.priority = UILayoutPriority(rawValue: 900)
            
            self.selectionHourLabel.isHidden = true
            self.viewLoadingDetail.isHidden = true
            self.buttonSwithOn.isHidden = true
        }else{
            let titleButton = String.facility_detail_lighting_action.uppercased()
            self.buttonSwithOn.setTitle(titleButton, for: .normal)
        }
    }
    
    func configureAvailableHours(currentHours:([Date], Bool)){
        self.configureStartHoursBooking(currentHours: currentHours.0, needNowTime: currentHours.1)
    }
    
    func configureAvailableEndHours(currentHours:[Date]){
        self.configureEndHoursBooking(currentHours: currentHours)
    }
    
    func configureHeaderViewWithFacility(currentFacility:AlFacility){
        self.setupHeaderView(currentFacility: currentFacility)
    }
    func configureBodyViewWithFacility(currentFacility:AlFacility, currentLat:Double?, currentLong:Double?){
        self.setupBodyView(currentFacility: currentFacility,currentLat:currentLat,currentLong:currentLong)
    }
    
    func configureSportsWithTypes(currentTypes: [Int]) {
        self.configureSportsInformation(currentSports: currentTypes)
    }
    
    func configureFieldsWithDates(currentFields:[AlField],startDate:Date?,endDate:Date?, currentType:Int){
        for currentView in self.stackFields.arrangedSubviews{
            currentView.removeFromSuperview()
        }
        for currentField in currentFields {
            if let currentName = currentField.nameField, let currentSportName = self.facilityDetailPresenter?.getNameSportByType(currentType:currentField.typeField), ( currentField.typeField == currentType || currentType == RankeetDefines.ContentServices.Facilities.sportTypeAll ) {
                if let views = Bundle.main.loadNibNamed("FacilityDetailFieldView", owner: self, options: nil) as? [FacilityDetailFieldView], views.count > 0, let currentView = views.first{
                    currentView.currentField = currentField
                    currentView.frame = CGRect(x: 0, y: 0, width: self.stackFields.frame.size.width, height: 80.0)
                    currentView.titleView.text = currentName+" "+currentSportName
                    currentView.delegate = self
                    self.facilityDetailPresenter?.requestFieldStateWithParemeters(currentField: currentField, startDate: startDate, endDate: endDate, currentView: currentView)
                    self.stackFields.addArrangedSubview(currentView)
                }
            }
        }
    }
    
    func configureFieldNotAvailableState(currentView:FacilityDetailFieldView,isSelected:Bool){
        currentView.buttonAction.isEnabled = false
        currentView.stateField.text = "EL CAMPO NO ESTÁ DISPONIBLE"
        currentView.imageField.image = UIImage(named:"ball")
        currentView.alpha = 0.5
        self.configureViewWithSelectedState(currentView: currentView, isSelected: isSelected)
    }
    
    func configureFieldNotAvailableStateBooked(currentView:FacilityDetailFieldView,isSelected:Bool){
        currentView.buttonAction.isEnabled = false
        currentView.stateField.text = "YA HAY UN PARTIDO EN EL CAMPO"
        currentView.imageField.image = UIImage(named:"ball")
        self.configureViewWithSelectedState(currentView: currentView, isSelected: isSelected)
    }
    
    func configureFieldAvailableState(currentView:FacilityDetailFieldView,isSelected:Bool){
        currentView.contentView.borderWidth = 1
        currentView.contentView.backgroundColor = UIColor.white
        currentView.titleView.textColor = RankeetDefines.Colors.aquaBlue
        currentView.contentView.layer.borderColor = RankeetDefines.Colors.aquaBlue.cgColor
        currentView.buttonAction.isEnabled = true
        currentView.stateField.text = "CAMPO DISPONIBLE"
        currentView.imageField.image = UIImage(named:"ball")
        self.configureViewWithSelectedState(currentView: currentView, isSelected: isSelected)
    }
    
    func configureFieldAvailableStateLighting(currentView:FacilityDetailFieldView, currentLighting:Int,isSelected:Bool){
        currentView.contentView.borderWidth = 1
        currentView.contentView.backgroundColor = UIColor.white
        currentView.titleView.textColor = RankeetDefines.Colors.aquaBlue
        currentView.contentView.layer.borderColor = RankeetDefines.Colors.aquaBlue.cgColor
        currentView.buttonAction.isEnabled = true
        currentView.stateField.text = "CAMPO DISPONIBLE"
        currentView.imageField.image = UIImage(named:"ball")
        self.configureViewWithSelectedState(currentView: currentView, isSelected: isSelected)
    }
    
    func configureViewWithSelectedState(currentView:FacilityDetailFieldView,isSelected:Bool){
        if isSelected {
            currentView.contentView.backgroundColor = RankeetDefines.Colors.aquaBlue
            currentView.imageField.image = UIImage(named:"ball")
            currentView.titleView.textColor = UIColor.white
            currentView.stateField.textColor = UIColor.white
        }
    }
    
    func loadNearFacilities(currentFacilities:[AlFacility]){

    }
}

extension FacilityDetailViewController : FacilityDetailFieldViewDelegate {
    func actionFromField(currentField: AlField?) {
        if let currentField = currentField {
            self.facilityDetailPresenter?.selectField(currentfield:currentField)
            self.checkResumLabel()
        }
    }
}

