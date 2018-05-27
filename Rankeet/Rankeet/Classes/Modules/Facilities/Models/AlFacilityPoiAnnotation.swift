//
//  AlFacilityPoiAnnotation.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import MapKit

class AlFacilityPoiAnnotation: NSObject, MKAnnotation {
    let currentFacility: AlFacility
    let currentLocation: UserPlace
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(CLLocationDegrees(currentFacility.latitude), CLLocationDegrees(currentFacility.longitude))
    }
    init(facility: AlFacility, userPlace:UserPlace) {
        self.currentFacility = facility
        self.currentLocation = userPlace
        super.init()
    }
    var title: String? { return currentFacility.nameFacility }
    var subtitle: String? { return  currentFacility.info?.address ?? "" }
}
