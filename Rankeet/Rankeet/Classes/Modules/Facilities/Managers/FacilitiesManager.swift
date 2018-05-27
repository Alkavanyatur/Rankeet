//
//  FacilitiesManager.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 24/1/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import MapKit

enum FaclityShowUserState {
    case unknown
    case available
    case availabreAndCurrLighting
    case noAvailable
    case reserved
}


class FacilitiesManager: NSObject {
}


//
// MARK: - List object methods
//

extension FacilitiesManager {
    
    func isRankeetLightingInFacility(currentFacility:AlFacility?)->Bool{
        if let currentFacility = currentFacility, let currentLightings = currentFacility.lightings {
            if  currentLightings.count == 0 {
                return false
            }else{
                return true
            }
        }
        return false
    }
    
    func isRankeetLightingOnInFacility(currentFacility:AlFacility?)->Bool{
        if let currentFacility = currentFacility, let currentLightings = currentFacility.lightings {
            for currentLighting in currentLightings{
                if currentLighting.lightState > 0{
                    return true
                }
            }
        }
        return false
    }
    
    func getCompleteListFacilitiesWithRankeet(completion:@escaping (AlFacilities?,RankeetError?)->Void){
        FacilititesDataProvider.sharedInstance.getFacilitiesList(searchText: nil, latitudeStart: nil, latitudeEnd: nil, longitudeStart: nil, longitudeEnd:nil, fieldType: nil,lightType:RankeetDefines.ContentServices.Facilities.RankeetLightingStateFilter,pageSize: nil, pageNum: nil) { (facilities, error) in
            completion(facilities,error)
        }
    }
    
    func getListNearFacilitiesWithRankeet(currentPlace:UserPlace,completion:@escaping (AlFacilities?,RankeetError?)->Void){
        let center = CLLocationCoordinate2D(latitude: currentPlace.latCoordinate, longitude: currentPlace.longCoordinate)
        FacilititesDataProvider.sharedInstance.getFacilitiesList(searchText: nil, latitudeStart: Float(center.latitude), latitudeEnd: nil, longitudeStart: Float(center.longitude), longitudeEnd: nil, fieldType: nil,lightType:RankeetDefines.ContentServices.Facilities.RankeetLightingStateFilter, pageSize: nil, pageNum: nil) { (facilities, error) in
            completion(facilities,error)
        }
    }

    func getListFacilitiesWithPlace(currentPlace:UserPlace,completion:@escaping (AlFacilities?,RankeetError?)->Void){
        let center = CLLocationCoordinate2D(latitude: currentPlace.latCoordinate, longitude: currentPlace.longCoordinate)
        let region = MKCoordinateRegionMakeWithDistance(center, CLLocationDistance(RankeetDefines.Location.diameterInitialSearch), CLLocationDistance(RankeetDefines.Location.diameterInitialSearch))
        
        FacilititesDataProvider.sharedInstance.getFacilitiesList(searchText: nil, latitudeStart: Float(region.southEast.latitude), latitudeEnd: Float(region.northWest.latitude), longitudeStart: Float(region.northWest.longitude), longitudeEnd: Float(region.southEast.longitude), fieldType: self.requestCurrentFilterStateType(),lightType:self.requestCurrentLightingFilter(), pageSize: nil, pageNum: nil) { (facilities, error) in
            completion(facilities,error)
        }
    }
    
    func getListFacilitiesWithRegion(region:MKCoordinateRegion,completion:@escaping (AlFacilities?,RankeetError?)->Void){        
        FacilititesDataProvider.sharedInstance.getFacilitiesList(searchText: nil, latitudeStart: Float(region.southEast.latitude), latitudeEnd: Float(region.northWest.latitude), longitudeStart: Float(region.northWest.longitude), longitudeEnd: Float(region.southEast.longitude), fieldType: self.requestCurrentFilterStateType(),lightType:self.requestCurrentLightingFilter(), pageSize: nil, pageNum: nil) { (facilities, error) in
            completion(facilities,error)
        }
    }
    
    func getListFacilitiesWithText(currentText:String,completion:@escaping (AlFacilities?,RankeetError?)->Void){
        FacilititesDataProvider.sharedInstance.getFacilitiesList(searchText: currentText, latitudeStart: nil, latitudeEnd: nil, longitudeStart: nil, longitudeEnd:nil, fieldType: nil,lightType:nil, pageSize: nil, pageNum: nil) { (facilities, error) in
            completion(facilities,error)
        }
    }
    
    func getFacilityDetail(currentIdFacility:String,completion:@escaping (AlFacility?,RankeetError?)->Void){
        FacilititesDataProvider.sharedInstance.getFacilityDetail(currentIdFacility: currentIdFacility) { (facility, error) in
            completion(facility,error)
        }
    }
}

//
// MARK: - Create reservation methods
//

extension FacilitiesManager {
    

}


//
// MARK: - Configuration methods
//

extension FacilitiesManager {
    
    func getHoursAvailableArrayByFacility(currentFacility:AlFacility, prevDate:Date?, currentType:Int) -> ([Date], Bool) {
        var currentHours:[Date] = []
        var needNowSelection:Bool = false
        let currentIntervaltime = SplashManager().requestGapTimeReservation()
        let currentMaxInterval = SplashManager().requestNumGapAllowed()
        guard  currentIntervaltime > 0, currentMaxInterval > 0 else {
            return (currentHours, needNowSelection)
        }
        
        if let currentFields = currentFacility.fields {
            for currentField in currentFields {
                if let currentConfiguration = currentField.configuration, (currentField.typeField == currentType || currentType == RankeetDefines.ContentServices.Facilities.sportTypeAll) {
                    for currentReservationTime in currentConfiguration.reservations {
                        if var currentStartHour = currentReservationTime.timeStart, let currentLastHour = currentReservationTime.timeEnd {
                            
                            if let currentPrevDate = prevDate {
                                let maxHourAllowed = currentPrevDate.addingTimeInterval(TimeInterval(currentMaxInterval*currentIntervaltime * 60))
                                while currentStartHour <= currentLastHour {
                                    if ( currentStartHour >= Date() ) && ( currentPrevDate.addingTimeInterval(TimeInterval(currentIntervaltime * 60)) <= currentStartHour  ) {
                                        if ( currentStartHour > currentPrevDate ) && ( maxHourAllowed >= currentStartHour ) {
                                            if self.checkIfHourCurrentlyOnArray(currentArray: currentHours, currenthour: currentStartHour) == false {
                                                currentHours.append(currentStartHour)
                                            }
                                        }
                                    }
                                    currentStartHour = currentStartHour.addingTimeInterval(TimeInterval(currentIntervaltime * 60))
                                }
                            }else{
                                while currentStartHour.addingTimeInterval(TimeInterval(currentIntervaltime * 60)) <= currentLastHour {
                                    if currentStartHour >= Date() {
                                        if self.checkIfHourCurrentlyOnArray(currentArray: currentHours, currenthour: currentStartHour) == false {
                                            currentHours.append(currentStartHour)
                                        }
                                    } else {
                                        if Date() <= currentLastHour {
                                            needNowSelection = true
                                        }
                                    }
                                    currentStartHour = currentStartHour.addingTimeInterval(TimeInterval(currentIntervaltime * 60))
                                }
                            }
                        }
                    }
                }
            }
        }
        currentHours = currentHours.sorted(by: { $0.compare($1) == .orderedAscending })
        return (currentHours, needNowSelection)
    }
    
    func checkIfHourCurrentlyOnArray(currentArray:[Date], currenthour:Date)-> Bool{
        for currentDate in currentArray{
            if currentDate == currenthour{
                return true
            }
        }
        return false
    }
    
    func getCurrentStateField(currentField:AlField, currentFacility:AlFacility,startDate:Date, endDate:Date)->FaclityShowUserState{
        guard let currentLightingDependencies = currentField.lightingDependencies, currentLightingDependencies.count > 0 else{
            return  .noAvailable
        }
        if let currentCurrentConfiguration = currentField.configuration{
            var allowedInOneSlot:Bool = false
            for currentReservation in currentCurrentConfiguration.reservations{
                if let currentStartTime = currentReservation.timeStart, let currentEndTime = currentReservation.timeEnd {
                    if currentStartTime <= startDate && currentEndTime >= endDate   {
                        allowedInOneSlot = true
                        break
                    }
                }
            }
            if allowedInOneSlot == false {
                return  .noAvailable
            }
            if let currentLightReservations = currentFacility.lightReservations{
                for currentReservation in currentLightReservations {
                    if let currentFieldId = currentField.idField, let currentReservationFieldId = currentReservation.idField, currentFieldId == currentReservationFieldId{
                        if let currentStartTime = currentReservation.timeStart, let currentEndTime = currentReservation.timeEnd {
                            if (startDate.time >= currentStartTime.time && startDate.time < currentEndTime.time) || (endDate.time > currentStartTime.time && endDate.time <= currentEndTime.time) || (startDate.time < currentStartTime.time && endDate.time > currentEndTime.time) {
                                return .reserved
                            }
                        }
                    }
                }
            }
            for currentLighting in currentCurrentConfiguration.lightings{
                if let currentStartTime = currentLighting.timeStart, let currentEndTime = currentLighting.timeEnd {
                    if (startDate >= currentStartTime && startDate < currentEndTime) || (endDate > currentStartTime && endDate <= currentEndTime) || (startDate < currentStartTime && endDate > currentEndTime) {
                        return .availabreAndCurrLighting
                    }
                }
            }
        }
        return FaclityShowUserState.available
    }
    
    func getFacilitySportNameById(currentId:Int)->String{
        return FacilititesDataProvider.sharedInstance.getFacilitySportNameById(currentId:currentId)
    }
    func getFacilitySportIconById(currentId:Int)->UIImage?{
        return FacilititesDataProvider.sharedInstance.getFacilitySportIconById(currentId:currentId)
    }
    
    func isFootBallSportField(currentId:Int)->Bool{
        return FacilititesDataProvider.sharedInstance.isFootBallSportField(currentId:currentId)
    }
    
    func isBasketSportField(currentId:Int)->Bool{
        return FacilititesDataProvider.sharedInstance.isBasketSportField(currentId:currentId)
    }
}

//
// MARK: - Filter methods
//

extension FacilitiesManager {
    
    func applyFiltersToStored(){
        FacilititesDataProvider.sharedInstance.applyFiltersToStored()
    }
    
    func restartScreenFilters(){
        FacilititesDataProvider.sharedInstance.restartScreenFilters()
    }
    
    func requestCurrentFilterStateType() -> String?{
        var stringFilter:String?
        let filters = self.requestSportFilters()
        for filter in filters{
            if let currentValueFilter = filter.valueFilter {
                if stringFilter == nil {
                    stringFilter = currentValueFilter
                }else{
                    stringFilter = (stringFilter ?? "") + "," + currentValueFilter
                }
            }
        }
        return stringFilter
    }
    
    func interactWithSportFilter(currentSports:ConfigSports){
        FacilititesDataProvider.sharedInstance.interactWithSportFilter(sportFilter:currentSports)
    }
    func requestSportFilters()->[ConfigSports]{
        return FacilititesDataProvider.sharedInstance.requestSportFilters()
    }
    func isSportFilterEnabled(currentFilter:ConfigSports)->Bool{
        let currentFilters = self.requestSportFilters()
        for filter in currentFilters {
            if filter.idFilter == currentFilter.idFilter {
                return true
            }
        }
        return false
    }
    
    func requestCurrentLightingFilter() -> String?{
        var stringFilter:String?
        let filters = self.requestLightingFilters()
        for filter in filters{
            var currentFilterString = "0"
            switch filter {
                case .Rankeet:
                    currentFilterString = "3"
                    break
                case .nolighting:
                    currentFilterString = "1"
                    break
                default:
                    currentFilterString = "2"
                    break
            }
            if stringFilter == nil {
                stringFilter = currentFilterString
            }else{
                stringFilter = (stringFilter ?? "") + "," + currentFilterString
            }
        }
        return stringFilter
    }
    
    func interactWithLightingFilter(lightingFilter:FilterStatesLighting){
        FacilititesDataProvider.sharedInstance.interactWithLightingFilter(lightingFilter:lightingFilter)
    }
    func requestLightingFilters()->[FilterStatesLighting]{
        return FacilititesDataProvider.sharedInstance.requestLightingFilters()
    }
    func isLightingFilterEnabled(currentFilter:FilterStatesLighting)->Bool{
        let currentFilters = self.requestLightingFilters()
        for filter in currentFilters {
            if filter == currentFilter {
                return true
            }
        }
        return false
    }
    func interactWithsizeFilter(sizeFilter:FilterStatesSize){
        FacilititesDataProvider.sharedInstance.interactWithsizeFilter(sizeFilter:sizeFilter)
    }
    func requestSizeFilters()->[FilterStatesSize]{
        return FacilititesDataProvider.sharedInstance.requestSizeFilters()
    }
    func isSizeFilterEnabled(currentFilter:FilterStatesSize)->Bool{
        let currentFilters = self.requestSizeFilters()
        for filter in currentFilters {
            if filter == currentFilter {
                return true
            }
        }
        return false
    }
    
    func isAnyFilterEnabled()->Bool{
        let currentSportFilters = self.requestSportFilters()
        guard currentSportFilters.isEmpty else {
            return true
        }
        let currentLightingFilters = self.requestLightingFilters()
        guard currentLightingFilters.isEmpty else {
            return true
        }
        let currentSizeFilters = self.requestSizeFilters()
        guard currentSizeFilters.isEmpty else {
            return true
        }
        return false
    }
}
