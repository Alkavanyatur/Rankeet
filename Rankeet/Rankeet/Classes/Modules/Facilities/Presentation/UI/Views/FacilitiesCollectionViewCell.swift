//
//  FacilitiesCollectionViewCell.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 3/4/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import CoreLocation
import AlamofireImage

class FacilitiesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var labelTypology: UILabel!
    
    @IBOutlet weak var imageTypology: UIImageView!
    @IBOutlet weak var imageFacility: UIImageView!
    @IBOutlet weak var favouritesButton: UIButton!
    
    @IBOutlet weak var emptySpaceImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func favouritesAction(_ sender: Any) {
        
    }
    
    func configureWithFacility(currentFacility:AlFacility, currentLat:Double?, currentLong:Double?,isFirstCell:Bool,needFavouriteAction:Bool){
        
        self.emptySpaceImage.image = UIImage(named: "imgCardEmptyspaceFootball")
        if let currentFields = currentFacility.fields {
            for currentField in currentFields {
                if FacilitiesManager().isBasketSportField(currentId: currentField.typeField) {
                    self.emptySpaceImage.image = UIImage(named: "imgCardEmptyspaceBasket")
                }
            }
        }
        if needFavouriteAction {
            self.favouritesButton.isHidden = false
        }else{
            self.favouritesButton.isHidden = true
        }
        if let currentLat = currentLat, let currentLong = currentLong{
            let coordinate₀ = CLLocation(latitude: Double(currentFacility.latitude), longitude: Double(currentFacility.longitude))
            let coordinate₁ = CLLocation(latitude: currentLat, longitude: currentLong)
            let distanceInMeters = coordinate₀.distance(from: coordinate₁)
            
            if distanceInMeters < 1000 {
                self.distanceLabel.text = String.facility_cell_distance_prefix + " \(Int(distanceInMeters)) m"
            }else{
                self.distanceLabel.text = String.facility_cell_distance_prefix + " \(Int(distanceInMeters/1000)) km"
            }
        }else{
            self.distanceLabel.text = ""
        }
        
        self.nameLabel.heroID = (currentFacility.idFacility)+"_name"
        self.favouritesButton.heroID = (currentFacility.idFacility)+"_bookmarks"
        self.emptySpaceImage.heroID = (currentFacility.idFacility)+"_empty_image"
        
        self.imageTypology.image = nil
        self.labelTypology.text = String.facility_cell_typology_no_Rankeet
        if FacilitiesManager().isRankeetLightingInFacility(currentFacility: currentFacility){
            if FacilitiesManager().isRankeetLightingOnInFacility(currentFacility: currentFacility){
                self.labelTypology.text = String.facility_cell_typology_Rankeet_lighting_on
                self.imageTypology.image = UIImage(named:"imgCardLightson")
            }else{
                self.labelTypology.text = String.facility_cell_typology_Rankeet_lighting_off
                self.imageTypology.image = UIImage(named:"imgCardLightsoff")
            }
        }
        
        self.addressLabel.text = currentFacility.info?.address ?? ""
        self.nameLabel.text = currentFacility.nameFacility
        
        if let currentImages = currentFacility.pictures, currentImages.count > 0{
            let currentImageObject = currentImages[0]
            if let currentImageId = currentImageObject.idImage, currentImageObject.scales.count > 0, let currentUrl = URL(string: FacilititesDataProvider.sharedInstance.getFacilityimageByIdAndImage(currentFacilityId: currentFacility.idFacility, currentScaleImage: currentImageObject.scales[1], currentIdImage: currentImageId)) {
                self.imageFacility.af_setImage(withURL: currentUrl)
            }else{
                self.imageFacility.image = nil
            }
        }else{
            self.imageFacility.image = nil
        }
        self.imageFacility.heroID  = (currentFacility.idFacility)+"_0"
    }
}
