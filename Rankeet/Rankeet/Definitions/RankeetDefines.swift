//
//  RankeetDefines.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18..
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

struct RankeetDefines {
    
    let services:ContentServices!
    init() {
        self.services = ContentServices()
    }
    
    struct ContentServices{
        static let fetchTimeRemoteConfig = 3600
        static let dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
        static let dateFormatSendReservation = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
        
        static let baseUrlDev = "http://ec2-34-215-174-5.us-west-2.compute.amazonaws.com:3001"
        
        static let baseUrl = RankeetDefines().services.baseUrlEnv
        var baseUrlEnv : String {
            return ContentServices.baseUrlDev
        }
        
        static let mockImageFacility = "http://www.solucionescancha.es/images/img/padel.jpg"
        
        struct Login{
            static let loginUser = "/user"
        }
        struct Facilities{
            static let sportTypeAll = -1
            
            static let getFacility = "/facility"
            static let getFacilities = "/facilities"
            static let RankeetLightingStateFilter = "3"
            
            static let image = "/facility/id/image"
        }
    }
    
    struct Colors{
        static let blueRan = UIColor(red: 0.204, green: 0.435, blue: 0.933, alpha: 1.0)
        static let aquaBlue = UIColor(red: 16.0 / 255.0, green: 204.0 / 255.0, blue: 209.0 / 255.0, alpha: 1.0)
        static let greyButtons = UIColor(red: 69.0 / 255.0, green: 69.0 / 255.0, blue: 69.0 / 255.0, alpha: 1.0)
        static let darkGrey = UIColor(red: 54.0 / 255.0, green: 54.0 / 255.0, blue: 54.0 / 255.0, alpha: 1.0)
        static let warmGrey = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
        static let greyish = UIColor(red: 182.0 / 255.0, green: 182.0 / 255.0, blue: 182.0 / 255.0, alpha: 1.0)
        static let pinkishGrey = UIColor(red: 206.0 / 255.0, green: 206.0 / 255.0, blue: 206.0 / 255.0, alpha: 1.0)
        static let greyWhite = UIColor(red: 241.0 / 255.0, green: 241.0 / 255.0, blue: 241.0 / 255.0, alpha: 1.0)
        static let brownishGrey = UIColor(red: 99.0 / 255.0, green: 99.0 / 255.0, blue: 99.0 / 255.0, alpha: 1.0)
        static let greyWhiteTwo = UIColor(red: 234.0 / 255.0, green: 234.0 / 255.0, blue: 234.0 / 255.0, alpha: 0.5)
        static let whiteAlpha = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.5)
        static let backgroundColor = UIColor(red: 0.200, green: 0.200, blue: 0.200, alpha: 1.00)
        static let clearGray = UIColor(red: 0.910, green: 0.910, blue: 0.910, alpha: 1.00)
        static let clearBlue = UIColor(red: 37.0 / 255.0, green: 107.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    struct Fonts{
        static let avenir_book_14 = UIFont(name: "Avenir-Book", size: 14)
        static let avenir_book_15 = UIFont(name: "Avenir-Book", size: 15)
        static let avenir_book_16 = UIFont(name: "Avenir-Book", size: 16)
        static let avenir_book_17 = UIFont(name: "Avenir-Book", size: 17)
        static let avenir_book_18 = UIFont(name: "Avenir-Book", size: 18)
        static let avenir_book_19 = UIFont(name: "Avenir-Book", size: 19)
        static let avenir_book_20 = UIFont(name: "Avenir-Book", size: 20)
        static let avenir_book_21 = UIFont(name: "Avenir-Book", size: 21)
        
        static let arial_rounded_mt_bold_14 = UIFont(name: "Arial Rounded MT Bold", size: 14)
        static let arial_rounded_mt_bold_15 = UIFont(name: "Arial Rounded MT Bold", size: 15)
        static let arial_rounded_mt_bold_16 = UIFont(name: "Arial Rounded MT Bold", size: 16)
        static let arial_rounded_mt_bold_17 = UIFont(name: "Arial Rounded MT Bold", size: 17)
        static let arial_rounded_mt_bold_18 = UIFont(name: "Arial Rounded MT Bold", size: 18)
        static let arial_rounded_mt_bold_19 = UIFont(name: "Arial Rounded MT Bold", size: 19)
        static let arial_rounded_mt_bold_20 = UIFont(name: "Arial Rounded MT Bold", size: 20)
    }
    
    struct RechargeValues{
        static let smallAmount = 5
        static let mediumAmount = 10
        static let largeAmount = 20
        
        static let centsMultiplier = 100
    }
    
    struct Notifications{
        static let notifications_requested = "Notifications_requested_key"
        static let notifications_first_iteration = "1"
        static let is_first_notifications_launch = "FIRST_NOTIFICATIONS_LAUNCH"
        
        static let notificationCategoryIdent = "ACTIONABLE"
        static let notificationActionOneIdent = "ACTION_ONE"
        static let notificationActionTwoIdent = "ACTION_TWO"
    }
    
    struct Location{
        static let maxDistanteKmFromMadridCenter = 70.0
        
        static let messageHeight = 47
        static let location_requested = "Location_requested_key"
        static let defaultLat = 40.4167
        static let defaultLong = -3.70325
        static let defaultNameLocation = "Madrid"
        static let diameterInitialSearch = 3000
    }
}
