//
//  FacilityMapView.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import CoreLocation

protocol FacilityMapViewDelegate: class {
    func detailsRequestedForFacility(facility: AlFacility)
}

class FacilityMapView: UIView {

    @IBOutlet weak var seeDetailsButton: UIButton!
    @IBOutlet weak var backgroundContentButton: UIButton!
    @IBOutlet weak var titleFacility: UILabel!
    @IBOutlet weak var subtitleFacility: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    // data
    var currentFacility: AlFacility!
    weak var delegate: FacilityMapViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // appearance
        self.backgroundContentButton.applyArrowDialogAppearanceWithOrientation(arrowOrientation: .down)
    }

    @IBAction func seeDetails(_ sender: Any) {
        self.delegate?.detailsRequestedForFacility(facility: self.currentFacility)
    }
    
    func configureWithFacility(facility: AlFacility, userLocation:UserPlace) {
        self.currentFacility = facility
        
        self.titleFacility.text = facility.nameFacility
        self.subtitleFacility.text = currentFacility.info?.address ?? ""
        
        let coordinate₀ = CLLocation(latitude: Double(facility.latitude), longitude: Double(facility.longitude))
        let coordinate₁ = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
        
        if distanceInMeters < 1000 {
            self.distanceLabel.text = String.facility_cell_distance_prefix + " \(Int(distanceInMeters)) m"
        }else{
            self.distanceLabel.text = String.facility_cell_distance_prefix + " \(Int(distanceInMeters/1000)) km"
        }
    }
    
    // MARK: - Hit test. We need to override this to detect hits in our custom callout.
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Check if it hit our annotation detail view components.
        
        // details button
        if let result = seeDetailsButton.hitTest(convert(point, to: seeDetailsButton), with: event) {
            return result
        }
        // fallback to our background content view
        return backgroundContentButton.hitTest(convert(point, to: backgroundContentButton), with: event)
    }
    
}
