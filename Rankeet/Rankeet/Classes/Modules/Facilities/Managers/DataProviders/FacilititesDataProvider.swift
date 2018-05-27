//
//  FacilititesDataProvider.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 24/1/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class FacilititesDataProvider: NSObject {
    
    static let sharedInstance = FacilititesDataProvider()
    
    var currentFiltersSportsPrev:[ConfigSports] = []
    var currentFiltersSports:[ConfigSports] = []
    
    var currentFiltersLightingPrev:[FilterStatesLighting] = []
    var currentFiltersLighting:[FilterStatesLighting] = []
    
    var currentFiltersSizePrev:[FilterStatesSize] = []
    var currentFiltersSize:[FilterStatesSize] = []
    
    override init() {
        super.init()
    }
    
    func getFacilitiesList(searchText:String?, latitudeStart:Float?, latitudeEnd:Float?, longitudeStart:Float?, longitudeEnd:Float?, fieldType:String?, lightType:String?, pageSize:Int?, pageNum:Int?,completion:@escaping (AlFacilities?,RankeetError?)->Void){
        let serviceUrl = RankeetDefines.ContentServices.baseUrl+RankeetDefines.ContentServices.Facilities.getFacilities
        let sessionManager = Alamofire.SessionManager.default
        let parameters:Parameters = ["text":searchText ?? "","latitudeStart":latitudeStart ?? "","latitudeEnd":latitudeEnd ?? "","longitudeStart":longitudeStart ?? "", "longitudeEnd":longitudeEnd ?? "", "fieldTypes":fieldType ?? "","lightType":lightType ?? "", "pageSize":pageSize ?? "", "pageNum":pageNum ?? ""]
        sessionManager.adapter = RankeetRequestAdapter(authToken: nil)
        sessionManager.request(serviceUrl, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil).responseString { (response) -> Void in
            
            guard response.response != nil, response.result.isSuccess, let value = response.result.value else {
                completion(nil,RankeetError.unknown)
                return
            }
            let facilities = Mapper<AlFacilities>().map(JSONString: value)
            guard facilities != nil else{
                completion(nil,RankeetError.unknown)
                return
            }
            completion(facilities,nil)
        }
    }
    
    func getFacilityDetail(currentIdFacility:String,completion:@escaping (AlFacility?,RankeetError?)->Void){
        let serviceUrl = RankeetDefines.ContentServices.baseUrl+RankeetDefines.ContentServices.Facilities.getFacility+"/"+currentIdFacility
        let sessionManager = Alamofire.SessionManager.default
        let parameters:Parameters = [:]
        sessionManager.adapter = RankeetRequestAdapter(authToken: nil)
        sessionManager.request(serviceUrl, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil).responseString { (response) -> Void in
            
            guard response.response != nil, response.result.isSuccess, let value = response.result.value else {
                completion(nil,RankeetError.unknown)
                return
            }
            let facility = Mapper<AlFacility>().map(JSONString: value)
            guard facility != nil else{
                completion(nil,RankeetError.unknown)
                return
            }
            completion(facility,nil)
        }
    }
    
    func getFacilityimageByIdAndImage(currentFacilityId:String, currentScaleImage:String, currentIdImage:String)->String{
        let hostImages = RankeetDefines.ContentServices.baseUrl
        let firstparameterImages = RankeetDefines.ContentServices.Facilities.image.replacingOccurrences(of: "/id", with: "/"+currentFacilityId)
        let finalParameterImages = "/" + currentIdImage + "/" + currentScaleImage
        return hostImages + firstparameterImages + finalParameterImages
    }
    
    func getFacilitySportNameById(currentId:Int)->String{
        return NSLocalizedString("sport_type_\(currentId)")
    }
    func getFacilitySportIconById(currentId:Int)->UIImage?{
        switch currentId {
        case 1,2,3:
            return UIImage(named:"icnFiltersFutballoff.png")
        case 4,5,6:
            return UIImage(named:"icnFiltersBasketoff.png")
        default:
            return UIImage(named:"icnFiltersOthersoff.png")
        }
    }
    
    func isFootBallSportField(currentId:Int)->Bool{
        switch currentId {
        case 1,2,3:
            return true
        default:
            return false
        }
    }
    
    func isBasketSportField(currentId:Int)->Bool{
        switch currentId {
        case 4,5,6:
            return true
        default:
            return false
        }
    }
}

//
// MARK: - Filter methods
//

extension FacilititesDataProvider {
    
    func applyFiltersToStored(){
        self.currentFiltersSports = self.currentFiltersSportsPrev
        self.currentFiltersLighting = self.currentFiltersLightingPrev
        self.currentFiltersSize = self.currentFiltersSizePrev
    }
    
    func restartScreenFilters(){
        self.currentFiltersSportsPrev = self.currentFiltersSports
        self.currentFiltersLightingPrev = self.currentFiltersLighting
        self.currentFiltersSizePrev = self.currentFiltersSize
    }

    func interactWithSportFilter(sportFilter:ConfigSports){
        for currentFilter in self.currentFiltersSportsPrev {
            if currentFilter.idFilter == sportFilter.idFilter {
                self.currentFiltersSportsPrev.remove(at: self.currentFiltersSportsPrev.index(of: currentFilter)!)
                return
            }
        }
        self.currentFiltersSportsPrev.append(sportFilter)
    }
    func requestSportFilters()->[ConfigSports]{
        return self.currentFiltersSports
    }
    func interactWithLightingFilter(lightingFilter:FilterStatesLighting){
        for currentFilter in self.currentFiltersLightingPrev {
            if currentFilter == lightingFilter {
                self.currentFiltersLightingPrev.remove(at: self.currentFiltersLightingPrev.index(of: currentFilter)!)
                return
            }
        }
        self.currentFiltersLightingPrev.append(lightingFilter)
    }
    func requestLightingFilters()->[FilterStatesLighting]{
        return self.currentFiltersLighting
    }
    func interactWithsizeFilter(sizeFilter:FilterStatesSize){
        for currentFilter in self.currentFiltersSizePrev {
            if currentFilter == sizeFilter {
                self.currentFiltersSizePrev.remove(at: self.currentFiltersSizePrev.index(of: currentFilter)!)
                return
            }
        }
        self.currentFiltersSizePrev.append(sizeFilter)
    }
    func requestSizeFilters()->[FilterStatesSize]{
        return self.currentFiltersSize
    }
}
