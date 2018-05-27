//
//  AlFieldConfiguration.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 24/1/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm
import DateToolsSwift

class AlFieldConfReservation: Object, Mappable {
    @objc dynamic var timeStart: Date?
    @objc dynamic var timeEnd: Date?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    // Mappable
    func mapping(map: Map) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  RankeetDefines.ContentServices.dateFormat
        
        let transformDate = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
            if let currentValue = value{
                let returnDate = dateFormatter.date(from: currentValue)
                return returnDate
            }else{
                return nil
            }
        }, toJSON: { (value: Date?) -> String? in
            // transform value from Int? to String?
            if let currentValue = value{
                return dateFormatter.string(from: currentValue)
            }else{
                return nil
            }
        })

        timeStart <- (map["timeStart"], transformDate)
        timeEnd <- (map["timeEnd"], transformDate)
    }
}


class AlFieldConfLighting: Object, Mappable {
    @objc dynamic var timeStart: Date?
    @objc dynamic var timeEnd: Date?
    
    @objc dynamic var lightType: Int = -1
    @objc dynamic var lightState: Int = -1
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    // Mappable
    func mapping(map: Map) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = RankeetDefines.ContentServices.dateFormat
        
        let transformDate = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
            if let currentValue = value{
                let returnDate = dateFormatter.date(from: currentValue)
                return returnDate
            }else{
                return nil
            }
        }, toJSON: { (value: Date?) -> String? in
            // transform value from Int? to String?
            if let currentValue = value{
                return dateFormatter.string(from: currentValue)
            }else{
                return nil
            }
        })
        
        timeStart <- (map["timeStart"], transformDate)
        timeEnd <- (map["timeEnd"], transformDate)
        
        lightType <- map["lightType"]
        lightState <- map["lightState"]
    }
}

class AlFieldConfiguration: Object, Mappable {
    
    var reservations = List<AlFieldConfReservation>()
    var lightings = List<AlFieldConfLighting>()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    // Mappable
    func mapping(map: Map) {
        reservations <- (map["reservations"], ListTransform<AlFieldConfReservation>())
        lightings <- (map["lightings"], ListTransform<AlFieldConfLighting>())
    }
}
