//
//  CLPlacemark+Address.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import CoreLocation

extension CLPlacemark {
    
    var compactAddress: String? {
        if let name = name {
            var result = name
            
            /*if let street = thoroughfare {
                result += ", \(street)"
            }*/
            
            if let city = locality {
                result += ", \(city)"
            }
            
            if let country = country {
                result += ", \(country)"
            }
            
            return result
        }
        
        return nil
    }
    
}
