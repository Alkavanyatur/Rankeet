//
//  AlImage.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 24/1/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class AlImageValue: Object {
    @objc dynamic var value = ""
}

class AlImage: Object, Mappable {
    
    @objc dynamic var idImage: String?
    
    var scalesFromRemote = List<AlImageValue>()
    var scales: [String] {
        var result = [String]()
        for scale in self.scalesFromRemote {
            result.append(scale.value)
        }
        return result
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func ignoredProperties() -> [String] {
        return ["scales"]
    }
    
    // Mappable
    func mapping(map: Map) {
        idImage <- map["_id"]
        if let unwrappedImagesValues = map.JSON["scales"] as? [String] {
            for imageValue in unwrappedImagesValues {
                let alImageValueObject = AlImageValue()
                alImageValueObject.value = imageValue
                self.scalesFromRemote.append(alImageValueObject)
            }
        }
    }
}
