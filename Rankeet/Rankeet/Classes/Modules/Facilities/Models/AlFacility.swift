//
//  AlFacility.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 24/1/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class AlFacilityInfo: Object, Mappable {
    
    @objc dynamic var address: String?
    @objc dynamic var info: String?
    @objc dynamic var infoLoc: String?
    @objc dynamic var bus: String?
    @objc dynamic var subway: String?
    @objc dynamic var train: String?
    @objc dynamic var district: String?
    @objc dynamic var neighborhood: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    // Mappable
    func mapping(map: Map) {
        address   <- map["address"]
        info    <- map["info"]
        infoLoc   <- map["infoLoc"]
        bus     <- map["bus"]
        subway   <- map["subway"]
        train   <- map["train"]
        district   <- map["district"]
        neighborhood   <- map["neighborhood"]
    }
}

class AlFacilityStored: Object {
    @objc dynamic var idFacility: String = ""
    @objc dynamic var facility: AlFacility?
    @objc dynamic var currentDate: Date = Date()
}

class AlFacility: Object,Mappable {
    
    @objc dynamic var idFacility: String = ""
    @objc dynamic var nameFacility: String = ""

    @objc dynamic var info: AlFacilityInfo?
    
    var fieldsRemote = List<AlField>()
    var fields: [AlField]?{
        var currentFields:[AlField] = []
        for field in self.fieldsRemote {
            currentFields.append(field)
        }
        return currentFields
    }
    
    var picturesRemote = List<AlImage>()
    var pictures: [AlImage]?{
        var currentPictures:[AlImage] = []
        for picture in self.picturesRemote {
            currentPictures.append(picture)
        }
        return currentPictures
    }
    
    @objc dynamic var latitude: Float = -1
    @objc dynamic var longitude: Float = -1
    
    var lightingsFromRemote =  List<AlLighting>()
    var lightings: [AlLighting]?{
        var currentLightings:[AlLighting] = []
        for lighting in self.lightingsFromRemote {
            currentLightings.append(lighting)
        }
        return currentLightings
    }
    
    var lightReservations : [AlLightReservation]?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func ignoredProperties() -> [String] {
        return ["lightReservations","fields","pictures","lightings"]
    }
    
    // Mappable
    func mapping(map: Map) {
        
        idFacility   <- map["_id"]
        nameFacility   <- map["name"]
        
        info   <- map["info"]
        
        fieldsRemote   <- (map["fields"], ListTransform<AlField>())
        picturesRemote   <- (map["images"], ListTransform<AlImage>())
        latitude   <- map["latitude"]
        longitude   <- map["longitude"]
        
        lightingsFromRemote   <- (map["lightings"], ListTransform<AlLighting>())
        lightReservations   <- map["lightReservations"]
    }
}
