//
//  DevDefines.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

struct DevDefines {
    static let datbaseVersion = 14.0
    
    struct Services{
        static let correct_code_http = 200
    }
    
    struct Metrics{
        static let is_iPhone = (UI_USER_INTERFACE_IDIOM() == .phone)
        static let isIphoneX = (is_iPhone && UIScreen.main.bounds.size.height == 812.0)
        
        static let widhtScreen = UIScreen.main.bounds.width
        static let heightScreen = UIScreen.main.bounds.height
        
        static let insetViewMap = (DevDefines.Metrics.heightScreen/8)*(5.3)
        static let insetNearFacilities = 20.0
        static let thresholdchangeStatus:CGFloat = -100.0
        
        struct HeaderView{
            static let maxSizeOnboarding:CGFloat = 110.0
            static let maxSize:CGFloat = 300.0
            static let minSize:CGFloat = 44.0
            
            static let maxSizeProfileHeader:CGFloat = 250.0
            static let minSizeProfileHeader:CGFloat = 64.0
            
            static let maxSizeBookingsDetail:CGFloat = 80.0
            static let maxSizeBookings:CGFloat = 124.0
            static let minSizeBookings:CGFloat = 44.0
        }
    }
    struct Onboarding{
        static let numSteps = 6.0
    }
    struct Animations{
        static let shortAnimationTime = 0.2
        static let quickAnimationTime = 0.3
        static let mediumAnimationTime = 0.5
        static let mediumAnimationTimePlus = 0.7
        static let mediumAnimationTimePlus2 = 0.7
        static let longAnimationTime = 1.0
        
        static let messagePresentOnScreen = 3.2
        
        static let animationTimeLogo = 2.0
        static let animationTimeCity = 5.0
    }
    struct Delay{
        static let delayToRemoveSplash = 2.0
        static let delayToRemoveFeedback = 2.0
        static let delayToShowLoading = 1.0
        static let delayToStopShowLoading = 0.5
        static let delayToStopLoadingProjectDetail = 0.5
        static let delayToProccedResultProjectDetail = 0.5
    }
}

