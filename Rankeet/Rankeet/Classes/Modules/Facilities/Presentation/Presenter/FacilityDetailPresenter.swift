//
//  FacilityDetailPresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 127/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import MapKit

protocol FacilityDetailPresenterDelegate: NSObjectProtocol {
    
    func configureHeaderViewWithFacility(currentFacility:AlFacility)
    func configureBodyViewWithFacility(currentFacility:AlFacility, currentLat:Double?, currentLong:Double?)
    func configureAvailableHours(currentHours:([Date], Bool))
    func configureAvailableEndHours(currentHours:[Date])
    func configureSportsWithTypes(currentTypes:[Int])
    func configureFieldsWithDates(currentFields:[AlField],startDate:Date?,endDate:Date?, currentType:Int)
    
    func configureFieldNotAvailableState(currentView:FacilityDetailFieldView,isSelected:Bool)
    func configureFieldNotAvailableStateBooked(currentView:FacilityDetailFieldView,isSelected:Bool)
    func configureFieldAvailableState(currentView:FacilityDetailFieldView,isSelected:Bool)
    func configureFieldAvailableStateLighting(currentView:FacilityDetailFieldView, currentLighting:Int,isSelected:Bool)
    
    func showloadingFacilityDetail()
    func hideLoadingFacilityDetail()
    
    func needExtraInfoRankeetSystem(needInfo:Bool)
    func questionNavigate(currentName:String, currentAddressLat:Float, currentAddressLong:Float)
    
    func loadNearFacilities(currentFacilities:[AlFacility])
    
    func configureWithSportName(currentName:String)
}

class FacilityDetailPresenter: NSObject {
    private weak var delegate: FacilityDetailPresenterDelegate?
    
    private var facilitiesManager : FacilitiesManager!
    
    private var currentFacility : AlFacility!
    private var currentPlace : UserPlace!
    private var currentSportSelected : Int = RankeetDefines.ContentServices.Facilities.sportTypeAll
    
    private var boolFacilityDetailLoaded : Bool = false
    
    private var currentStartTime:Date?
    private var currentEndTime:Date?
    
    private var currentField:AlField?

    init(delegate: FacilityDetailPresenterDelegate,currentFacility:AlFacility,currentPlace:UserPlace) {
        self.delegate = delegate
        
        self.facilitiesManager = FacilitiesManager()
        
        self.currentFacility = currentFacility
        self.currentPlace = currentPlace
    }
    
    //
    // MARK: - Public methods
    //
    func viewDidAppear(fromOnboarding:Bool){
        self.delegate?.configureHeaderViewWithFacility(currentFacility: self.currentFacility)
        self.delegate?.configureBodyViewWithFacility(currentFacility: self.currentFacility,currentLat: self.currentPlace.coordinate.latitude, currentLong: self.currentPlace.coordinate.longitude)
        self.checkSportsAllowed()
        if let currentFields = self.currentFacility.fields {
            self.delegate?.configureFieldsWithDates(currentFields:currentFields, startDate: nil, endDate: nil, currentType: self.currentSportSelected)
        }
        
        let isRankeetInFacility = self.isRankeetLightingInFacility(currentFacility: self.currentFacility)
        self.delegate?.needExtraInfoRankeetSystem(needInfo: isRankeetInFacility)
        if isRankeetInFacility {
            self.requestFacilityDetail()
        }
        if fromOnboarding == false {
            self.facilitiesManager.getListNearFacilitiesWithRankeet(currentPlace: self.currentPlaceUser(), completion: { (facilities, error) in
                if let facilities = facilities?.objects {
                    var facilitiesFiltered:[AlFacility] = []
                    for currentFacilityFromRemote in facilities {
                        if currentFacilityFromRemote.idFacility != self.currentFacility.idFacility {
                            facilitiesFiltered.append(currentFacilityFromRemote)
                        }
                    }
                    self.delegate?.loadNearFacilities(currentFacilities: facilitiesFiltered)
                }
            })
        }
    }
    
    func addressActionMethod(){
        self.delegate?.questionNavigate(currentName:self.currentFacility.nameFacility,currentAddressLat: self.currentFacility.latitude, currentAddressLong:self.currentFacility.longitude)
    }
    
    func googleMapsAction(currentLat:Float, currentLong:Float){
        UIApplication.shared.openURL(URL(string:"comgooglemaps://?center=\(currentLat),\(currentLong)&zoom=14&views=traffic")!)
    }
    
    func appleMapsAction(currentName:String, currentLat:Float, currentLong:Float){
        let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(currentLat), CLLocationDegrees(currentLong))
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = currentName
        mapItem.openInMaps(launchOptions:nil)
    }
    
    func checkSportsAllowed(){
        var currentSports:[Int] = []
        if let fields = self.currentFacility.fields{
            for field in fields {
                if self.alreadyAddedSportType(sports: currentSports, currentType: field.typeField) == false {
                    currentSports.append(field.typeField)
                }
            }
        }
        self.delegate?.configureSportsWithTypes(currentTypes: currentSports)
    }
    
    func getNameSportByType(currentType:Int)-> String{
        return self.facilitiesManager.getFacilitySportNameById(currentId: currentType)
    }
    
    func alreadyAddedSportType(sports:[Int],currentType:Int)->Bool{
        for sport in sports{
            if sport == currentType{
                return true
            }
        }
        return false
    }
    
    func selectStartHour(currentHour:Date?){
        guard currentHour != nil else {
            return
        }
        self.currentStartTime = currentHour
        self.currentEndTime = nil
        self.delegate?.configureAvailableEndHours(currentHours: self.facilitiesManager.getHoursAvailableArrayByFacility(currentFacility: self.currentFacility,prevDate: self.currentStartTime, currentType: self.currentSportSelected).0)
        if let currentFields = self.currentFacility.fields {
            self.delegate?.configureFieldsWithDates(currentFields:currentFields, startDate: nil, endDate: nil, currentType: self.currentSportSelected)
        }
    }
    
    func selectEndHour(currentHour:Date?){
        guard self.currentStartTime != nil, currentHour != nil else{
            return
        }
        self.currentEndTime = currentHour
        if let currentFields = self.currentFacility.fields {
            self.delegate?.configureFieldsWithDates(currentFields: currentFields,startDate: self.currentStartTime, endDate: self.currentEndTime, currentType: self.currentSportSelected)
        }
    }
    
    func deSelectField(){
        self.currentField = nil
    }
    
    func selectField(currentfield:AlField){
        self.currentField = currentfield
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm yyyy-MM-dd"
        if let currentEnd = self.currentEndTime, let currentStart = self.currentStartTime {
            if let currentFields = self.currentFacility.fields {
                self.delegate?.configureFieldsWithDates(currentFields: currentFields,startDate: currentStart, endDate: currentEnd, currentType: self.currentSportSelected)
            }
        }
    }
    
    func requestCurrentStateResumeLabel()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        guard currentStartTime != nil else{
            return String.facility_detail_select_hour
        }
        guard currentEndTime != nil else{
            return formatter.string(from:currentStartTime!) + " | " + String.facility_detail_until_time
        }
        guard currentField != nil, let currentFieldName = currentField!.nameField else{
            return formatter.string(from:currentStartTime!) + " | " + formatter.string(from:currentEndTime!) + " " + String.facility_detail_select_field
        }
        return formatter.string(from:currentStartTime!) + " - " + formatter.string(from:currentEndTime!) + " | " + currentFieldName
    }
    
    func requestCurrentStateSwitchOnLabel()->String{
        guard currentField != nil else{
            return "ENCENDER"
        }
        if let currentPrice = currentField?.lightPrice, currentPrice > 0 {
            return "\(currentPrice/100)€ ENCENDER"
        }
        return "ENCENDER"
    }
    
    func enableSwithOnButton()->Bool{
        guard currentStartTime != nil else{
            return false
        }
        guard currentEndTime != nil else{
            return false
        }
        guard currentField != nil, let _ = currentField!.nameField else{
            return false
        }
        return true
    }
    
    func requestFieldStateWithParemeters(currentField:AlField,startDate:Date?,endDate:Date?,currentView:FacilityDetailFieldView){
        var isSelected = false
        if let field = self.currentField, let currentFieldId = field.idField, let remoteFieldId = currentField.idField, currentFieldId == remoteFieldId{
            isSelected = true
        }
        if let startDate = startDate, let endDate = endDate {
            let currentState = self.facilitiesManager.getCurrentStateField(currentField: currentField, currentFacility: self.currentFacility, startDate: startDate, endDate: endDate)
            switch currentState{
            case .available:
                self.delegate?.configureFieldAvailableState(currentView: currentView,isSelected:isSelected)
            case .availabreAndCurrLighting:
                self.delegate?.configureFieldAvailableStateLighting(currentView: currentView, currentLighting: 100,isSelected:isSelected)
            case .reserved:
                self.delegate?.configureFieldNotAvailableStateBooked(currentView: currentView,isSelected:isSelected)
            default:
                self.delegate?.configureFieldNotAvailableState(currentView: currentView,isSelected:isSelected)
            }
        }else{
            self.delegate?.configureFieldNotAvailableState(currentView: currentView,isSelected:isSelected)
        }
    }
    
    func backFromDetail(){
        self.transitionToBackList()
    }
    func hideFromDetail(){
        self.hideFromDetailTransition()
    }
    
    func isRankeetLightingInFacility(currentFacility: AlFacility?) -> Bool{
        return self.facilitiesManager.isRankeetLightingInFacility(currentFacility:currentFacility)
    }
    
    func isRankeetLightingOnInFacility(currentFacility: AlFacility?) -> Bool{
        return self.facilitiesManager.isRankeetLightingOnInFacility(currentFacility:currentFacility)
    }
    
    func currentPlaceUser()-> UserPlace {
        return self.currentPlace
    }
    
    func selectFacilityDetail(currentFacility:AlFacility){
        self.transitionToFacilityDetail(currentFacility:currentFacility)
    }
    
    //
    // MARK: - Request data methods
    //
    func requestFacilityDetail(){
        self.delegate?.showloadingFacilityDetail()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + DevDefines.Delay.delayToRemoveSplash) {
            self.facilitiesManager.getFacilityDetail(currentIdFacility: self.currentFacility.idFacility) { (facility, error) in
                self.boolFacilityDetailLoaded = true
                self.currentFacility = facility
                self.delegate?.hideLoadingFacilityDetail()
                
                let currentHours = self.facilitiesManager.getHoursAvailableArrayByFacility(currentFacility: self.currentFacility,prevDate: nil, currentType: self.currentSportSelected)
                if currentHours.0.count > 0 {
                    self.delegate?.configureAvailableHours(currentHours: currentHours)
                    self.delegate?.configureAvailableEndHours(currentHours: self.facilitiesManager.getHoursAvailableArrayByFacility(currentFacility: self.currentFacility,prevDate: nil, currentType: self.currentSportSelected).0)
                }
            }
        }
    }
    
    //
    // MARK: - Create reservation data methods
    //
    func createReservationAction(){
        if let currentField = self.currentField, let currentStartDate = self.currentStartTime, let currentEndDate = self.currentEndTime {
            let currentReservation = AlLightReservation(currentStartDate: currentStartDate, currentEndDate: currentEndDate, currentField: currentField, currentFacility: self.currentFacility)
            
        }
    }
    
    
    //
    // MARK: - Select sport methods
    //
    func selectSportAction(){
        self.selectSportTransition()
    }
}


//
// MARK: - Transition Methods
//

extension FacilityDetailPresenter{
    
    func transitionToBackList(){
        RouterManager.shared.visibleViewController?.dismiss(animated: true, completion: nil)
    }
    func hideFromDetailTransition(){
        RouterManager.shared.visibleViewController?.dismiss(animated: true, completion: {
            if let currentController = RouterManager.shared.visibleViewController as? OnboardingNavigationViewController {
                currentController.dismissAction(self)
            }
        })
    }
    
    func transitionToBackListAndChangeToReservation(){
        RouterManager.shared.visibleViewController?.dismiss(animated: true, completion: {})
        RouterManager.shared.visibleViewController?.dismiss(animated: false, completion: {
            if let visibleController = RouterManager.shared.visibleViewController as? MainStructureViewController{
                //visibleController.selectedIndex = 1
            }else  if let currentController = RouterManager.shared.visibleViewController as? OnboardingNavigationViewController {
                currentController.dismissAction(self)
            }
        })
    }
    
    func transitionToFacilityDetail(currentFacility:AlFacility){
        let facilityFlexibleHeaderContainerViewController:FacilityFlexibleHeaderContainerViewController = FacilityFlexibleHeaderContainerViewController(currentFacility:currentFacility,currentPlace:self.currentPlace,fromOnboarding:false)
        RouterManager.shared.visibleViewController?.dismiss(animated: true, completion: {
            RouterManager.shared.visibleViewController?.present(facilityFlexibleHeaderContainerViewController, animated: true, completion: nil)
        })
    }
    
    func transitionToLogin(lightReservation:AlLightReservation){
        
    }
    
    func selectSportTransition(){
        let sportSelectionViewController:SportSelectionViewController = SportSelectionViewController.instantiate(currentFacility: self.currentFacility, currentNavigationDelegate: self)
        RouterManager.shared.visibleViewController?.present(sportSelectionViewController, animated: true, completion: {
        })
    }
}

//
// MARK: - Transition Methods
//

extension FacilityDetailPresenter: SportsSelectionNavigationDelegate{
    func selectSportFromUser(currentSports: Int) {
        self.currentSportSelected = currentSports
        if currentSports == RankeetDefines.ContentServices.Facilities.sportTypeAll {
            self.delegate?.configureWithSportName(currentName: String.facility_sport_selection_any_sport)
        }else{
            self.delegate?.configureWithSportName(currentName: self.facilitiesManager.getFacilitySportNameById(currentId: currentSports))
        }
        if let currentFields = self.currentFacility.fields {
            self.delegate?.configureFieldsWithDates(currentFields:currentFields, startDate: nil, endDate: nil,currentType:self.currentSportSelected)
        }
        let currentHours = self.facilitiesManager.getHoursAvailableArrayByFacility(currentFacility: self.currentFacility,prevDate: nil, currentType: self.currentSportSelected)
        if currentHours.0.count > 0 {
            self.delegate?.configureAvailableHours(currentHours: currentHours)
            self.delegate?.configureAvailableEndHours(currentHours: self.facilitiesManager.getHoursAvailableArrayByFacility(currentFacility: self.currentFacility,prevDate: nil, currentType: self.currentSportSelected).0)
        }
    }
}
