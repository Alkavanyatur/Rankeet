//
//  AlFacilities.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 24/1/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ObjectMapper

class AlFacilities: Mappable {
    
    var total: Int?
    var objects: [AlFacility]?
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        total   <- map["total"]
        objects   <- map["objects"]
    }
}
