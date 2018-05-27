//
//  MKCoordinateRegion+Corners.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import MapKit

extension MKCoordinateRegion {
    var northWest: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: center.latitude + span.latitudeDelta  / 2,
                                      longitude: center.longitude - span.longitudeDelta / 2)
    }
    var northEast: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: center.latitude + span.latitudeDelta  / 2,
                                      longitude: center.longitude + span.longitudeDelta / 2)
    }
    var southWest: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: center.latitude - span.latitudeDelta  / 2,
                                      longitude: center.longitude - span.longitudeDelta / 2)
    }
    var southEast: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: center.latitude - span.latitudeDelta  / 2,
                                      longitude: center.longitude + span.longitudeDelta / 2)
    }
}
