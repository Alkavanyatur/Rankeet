//
//  SplashDataProvider.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import FirebaseRemoteConfig

class SplashDataProvider: NSObject {
    
    var remoteConfig: RemoteConfig!
    static let sharedInstance = SplashDataProvider()
    
    override init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.configSettings = remoteConfigSettings!
        remoteConfig.setDefaults(fromPlist: "RemoteConfig")
        super.init()
    }
    
    func checkRemoteConfigValues(completion:@escaping (Bool,String)->Void){
        var expirationDuration = RankeetDefines.ContentServices.fetchTimeRemoteConfig
        if remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 0
        }
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
            if status == .success {
                self.remoteConfig.activateFetched()
            }
            completion(self.remoteConfig["needShowOnboarding"].boolValue, self.remoteConfig["iosAppMinVersion"].stringValue ?? "")
        }
        
    }
    
    func requestSportsFromConfiguration()->[ConfigSports]{
        var configSports:[ConfigSports] = []
        var inititalTag = 101
        
        if let currentSportsString = self.remoteConfig["sports"].stringValue{
            let currentComponents = currentSportsString.components(separatedBy: "|")
            for element in currentComponents {
                let filterElements = element.components(separatedBy: ";")
                if filterElements.count > 1 {
                    configSports.append(ConfigSports(idFilter: inititalTag, nameFilter: self.nameSportFilterbyId(currentSportId: filterElements[0]), valueFilter: filterElements[0]))
                    inititalTag = inititalTag+1
                }
            }
        }
        return configSports
    }
    
    func nameSportFilterbyId(currentSportId:String) -> String{
        if currentSportId == "1,2,3"{
            return String.sport_type_123
        }else if currentSportId == "4,5,6"{
            return String.sport_type_456
        }else if currentSportId == "7"{
            return String.sport_type_7
        }else if currentSportId == "8"{
            return String.sport_type_8
        }else if currentSportId == "9"{
            return String.sport_type_9
        }else if currentSportId == "10"{
            return String.sport_type_10
        }else if currentSportId == "11"{
            return String.sport_type_11
        }else if currentSportId == "12"{
            return String.sport_type_12
        }else if currentSportId == "13"{
            return String.sport_type_13
        }else if currentSportId == "14"{
            return String.sport_type_14
        }else if currentSportId == "15"{
            return String.sport_type_15
        }else if currentSportId == "16"{
            return String.sport_type_16
        }else if currentSportId == "17"{
            return String.sport_type_17
        }else if currentSportId == "18"{
            return String.sport_type_18
        }else if currentSportId == "19"{
            return String.sport_type_19
        }else if currentSportId == "20"{
            return String.sport_type_20
        }else if currentSportId == "21"{
            return String.sport_type_21
        }
        return String.sport_type_123
    }
    
    func requestGapTimeReservation()-> Int {
        if let currentNumber = self.remoteConfig["gapTimeReservation"].numberValue{
            return currentNumber.intValue
        }
        return 0
    }
    
    func requestNumGapAllowed()-> Int {
        if let currentNumber = self.remoteConfig["numGapAllowed"].numberValue{
            return currentNumber.intValue
        }
        return 0
    }
}
