//
//  AlGenericResponse.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ObjectMapper

class AlGenericResponse: Mappable {

    var n: Int?
    var ok: Int?
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        
        n <- map["n"]
        ok <- map["ok"]
    }
}
