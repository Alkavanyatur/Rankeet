//
//  AlFacilityPoiAnnotationView.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import MapKit

private let kFacilityMapPinImage = UIImage(named: "ic_place_map")!
private let kFacilityMapAnimationTime = 0.300

class AlFacilityPoiAnnotationView: MKAnnotationView {

    // data
    weak var facilityMapViewDelegate: FacilityMapViewDelegate?
    weak var customCalloutView: FacilityMapView?
    override var annotation: MKAnnotation? {
        willSet { customCalloutView?.removeFromSuperview() }
    }
    
    // MARK: - life cycle
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        self.image = kFacilityMapPinImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false // This is important: Don't show default callout.
        self.image = kFacilityMapPinImage
    }
    
    // MARK: - callout showing and hiding
    // Important: the selected state of the annotation view controls when the
    // view must be shown or not. We should show it when selected and hide it
    // when de-selected.
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.customCalloutView?.removeFromSuperview() // remove old custom callout (if any)
            
            if let newCustomCalloutView = loadFacilityMapView() {
                // fix location from top-left to its right place.
                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
                newCustomCalloutView.frame.origin.y = 35.0
                
                // set custom callout view
                self.addSubview(newCustomCalloutView)
                self.customCalloutView = newCustomCalloutView
                
                // animate presentation
                if animated {
                    self.customCalloutView!.alpha = 0.0
                    UIView.animate(withDuration: kFacilityMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 1.0
                    })
                }
            }
        } else {
            if customCalloutView != nil {
                if animated { // fade out animation, then remove it.
                    UIView.animate(withDuration: kFacilityMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 0.0
                    }, completion: { (success) in
                        self.customCalloutView!.removeFromSuperview()
                    })
                } else { self.customCalloutView!.removeFromSuperview() } // just remove it.
            }
        }
    }
    
    func loadFacilityMapView() -> FacilityMapView? {
        if let views = Bundle.main.loadNibNamed("FacilityMapView", owner: self, options: nil) as? [FacilityMapView], views.count > 0 {
            let facilityMapView = views.first!
            facilityMapView.delegate = self.facilityMapViewDelegate
            if let alFacilityPoiAnnotation = annotation as? AlFacilityPoiAnnotation {
                let currentFacility = alFacilityPoiAnnotation.currentFacility
                facilityMapView.configureWithFacility(facility: currentFacility,userLocation: alFacilityPoiAnnotation.currentLocation)
            }
            return facilityMapView
        }
        return nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
    }
    
    // MARK: - Detecting and reaction to taps on custom callout.
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // if super passed hit test, return the result
        if let parentHitView = super.hitTest(point, with: event) { return parentHitView }
        else { // test in our custom callout.
            if customCalloutView != nil {
                return customCalloutView!.hitTest(convert(point, to: customCalloutView!), with: event)
            } else { return nil }
        }
    }
}
