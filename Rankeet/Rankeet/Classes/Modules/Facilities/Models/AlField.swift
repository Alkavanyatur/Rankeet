//
//  AlField.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 24/1/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class AlDependencies: Object, Mappable {
    
    @objc dynamic var idDependency = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        idDependency   <- map["_id"]
    }
}

class AlField: Object, Mappable {
    
    @objc dynamic var idField: String?
    @objc dynamic var typeField: Int = -1
    @objc dynamic var nameField: String?
    @objc dynamic var info: String?
    var pictures: List<AlImage>?
    @objc dynamic var latitude: Float = -1
    @objc dynamic var longitude: Float = -1
    @objc dynamic var lightPrice: Int = 0
    @objc dynamic var configuration: AlFieldConfiguration?
    var lightingDependencies: List<AlDependencies>?
    var bookDependencies: List<AlDependencies>?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    // Mappable
    func mapping(map: Map) {
        idField   <- map["_id"]
        typeField    <- map["type"]
        nameField   <- map["nameLoc"]
        info     <- map["infoLoc"]
        pictures   <- (map["pictures"], ListTransform<AlImage>())
        latitude   <- map["latitude"]
        longitude   <- map["longitude"]
        lightPrice   <- map["lightPrice"]
        configuration   <- map["configurationTimes"]
        
        lightingDependencies   <- (map["lightingDependencies"], ListTransform<AlDependencies>())
        bookDependencies   <- (map["bookDependencies"], ListTransform<AlDependencies>())
    }
}
