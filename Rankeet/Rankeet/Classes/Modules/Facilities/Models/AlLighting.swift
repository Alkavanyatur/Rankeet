//
//  AlLighting.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 24/1/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

enum AlLightingType:Int {
    case none
    case no_light
    case light
    case smart
}

enum AlLightingFieldType:Int {
    case none
    case no_led
    case led_no_dimmable
    case led_dimmable
}

enum AlLightingReservationState:Int {
    case created
    case paid
    case finished
    case cancelled_while
    case cancelled_before
    case deleted
}

class AlLighting: Object, Mappable {
    
    @objc dynamic var idLighting: String?
    @objc dynamic var idPerfectplay: String?
    @objc dynamic var lightType:Int = -1
    @objc dynamic var lightState: Int = -1
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    // Mappable
    func mapping(map: Map) {
        idLighting <- map["_id"]
        idPerfectplay <- map["idPerfectplay"]
        lightType <- map["lightType"]
        lightState <- map["lightState"]
    }
}
