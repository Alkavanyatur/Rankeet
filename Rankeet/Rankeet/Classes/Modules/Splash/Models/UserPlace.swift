//
//  UserPlace.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import RealmSwift
import MapKit

class UserPlace: Object {
    
    @objc dynamic var idGoogle = ""
    @objc dynamic var address = ""
    @objc dynamic var timestamp = 0.0
    
    @objc dynamic var latCoordinate = 0.0
    @objc dynamic var longCoordinate = 0.0
    
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latCoordinate,
            longitude: longCoordinate)
    }
    
    override static func primaryKey() -> String? {
        return "idGoogle"
    }
}
