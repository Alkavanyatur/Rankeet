//
//  ChangeLocationTableViewCell.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/2/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import GooglePlaces

class ChangeLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var separator: UIImageView!
    @IBOutlet weak var locationIndicator: UIImageView!
    @IBOutlet weak var adressIndicator: UIImageView!
    @IBOutlet weak var restoreSearchIndicator: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    
    var isStoredPlace:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCellWithStoredPlaceItem(storedPlace:UserPlace?, andIsLast:Bool){
        if let currentPlace = storedPlace {
            self.isStoredPlace = true
            self.adressIndicator.isHidden = true
            self.locationIndicator.isHidden = true
            self.restoreSearchIndicator.isHidden = false
            
            self.labelLocation.text = currentPlace.address
        }
        if andIsLast {
            self.separator.isHidden = true
        }else{
            self.separator.isHidden = false
        }
    }

    func configureCellWithGooglePlaceItem(prediction:GMSAutocompletePrediction, andIsLast:Bool){
        self.isStoredPlace = false
        self.adressIndicator.isHidden = true
        self.locationIndicator.isHidden = false
        self.restoreSearchIndicator.isHidden = true
        
        self.labelTitle.text = nil
        self.labelLocation.text = prediction.attributedFullText.string
        if andIsLast {
            self.separator.isHidden = true
        }else{
            self.separator.isHidden = false
        }
    }
    
    func configureCellWithFacility(currentFacility:AlFacility, andIsLast:Bool){
        self.isStoredPlace = false
        self.adressIndicator.isHidden = false
        self.locationIndicator.isHidden = true
        self.restoreSearchIndicator.isHidden = true
        
        self.labelTitle.text = currentFacility.nameFacility
        self.labelLocation.text = currentFacility.info?.address ?? ""
        if andIsLast {
            self.separator.isHidden = true
        }else{
            self.separator.isHidden = false
        }
    }
}
