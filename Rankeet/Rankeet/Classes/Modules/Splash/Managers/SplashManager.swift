//
//  SplashManager.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

class SplashManager: NSObject {

}



//
// MARK: - Remote config methods
//

extension SplashManager {
    func requestRemoteConfigurationValues(completion:@escaping (Bool,String) -> Void){
        SplashDataProvider.sharedInstance.checkRemoteConfigValues { (needOnboarding, AppVersion) in
            completion(needOnboarding,AppVersion)
        }
    }
    
    func requestConfigSports()->[ConfigSports]{
        return SplashDataProvider.sharedInstance.requestSportsFromConfiguration()
    }
    
    func requestGapTimeReservation()-> Int {
        return SplashDataProvider.sharedInstance.requestGapTimeReservation()
    }

    func requestNumGapAllowed()-> Int {
        return SplashDataProvider.sharedInstance.requestNumGapAllowed()
    }
}
