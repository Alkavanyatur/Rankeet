//
//  FacilitiesTableViewCell.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import CoreLocation
import AlamofireImage
import FaveButton

protocol FacilitiesTableViewCellDelegate: NSObjectProtocol {
    func toggleBookmarkFacility()
}

class FacilitiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var heightDistance: NSLayoutConstraint!
    weak var delegate: FacilitiesTableViewCellDelegate?
    
    @IBOutlet weak var tableIndicator: UIView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var labelTypology: UILabel!
    
    @IBOutlet weak var imageTypology: UIImageView!
    @IBOutlet weak var imageFacility: UIImageView!
    @IBOutlet weak var emptySpaceImage: UIImageView!
    
    @IBOutlet weak var favPlaceHolder: UIImageView!
    @IBOutlet weak var favouritesButton: FaveButton!
    var currentFacility: AlFacility!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func favouritesAction(_ sender: Any) {
        if FavouritesManager().isFacilityFavourite(currentFacility: self.currentFacility){
            FavouritesManager().removeFacilityFavourite(currentFacility: self.currentFacility)
        }else{
            FavouritesManager().addFacilityFavourite(currentFacility: self.currentFacility)
        }
        self.delegate?.toggleBookmarkFacility()
    }
    
    func configureWithFacility(currentFacility:AlFacility, currentLat:Double?, currentLong:Double?,isFirstCell:Bool,needFavouriteAction:Bool, fromOnboarding:Bool){
        self.currentFacility = currentFacility
        
        self.emptySpaceImage.image = UIImage(named: "imgCardEmptyspaceFootball")
        if let currentFields = currentFacility.fields {
            for currentField in currentFields {
                if FacilitiesManager().isBasketSportField(currentId: currentField.typeField) {
                    self.emptySpaceImage.image = UIImage(named: "imgCardEmptyspaceBasket")
                }
            }
        }
        
        if fromOnboarding {
            self.heightDistance.constant = 0.0
        }else{
            self.heightDistance.constant = 21.0
        }
        
        if isFirstCell {
            self.tableIndicator.isHidden = false
        }else{
            self.tableIndicator.isHidden = true
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
        
        if FavouritesManager().isFacilityFavourite(currentFacility: currentFacility){
            self.favouritesButton.setSelected(selected: true, animated: false)
        }else{
            self.favouritesButton.setSelected(selected: false, animated: false)
        }
        self.favouritesButton.heroID = (currentFacility.idFacility)+"_bookmarks"
        self.favPlaceHolder.heroID = (currentFacility.idFacility)+"_bookmarks_place"
        self.emptySpaceImage.heroID = (currentFacility.idFacility)+"_empty_image"
        
        self.imageTypology.image = nil
        self.labelTypology.text = String.facility_cell_typology_no_Rankeet
        
        let num:Int = Int(arc4random_uniform(10))
        if num > 5 {
            self.labelTypology.text = "HAY UN PARTIDO EN JUEGO!"
            self.imageTypology.image = UIImage(named:"ball")
        }else{
            self.labelTypology.text = "NO HAY NINGÚN PARITDO EN JUEGO"
            self.imageTypology.image = nil
        }
        
        self.addressLabel.text = currentFacility.info?.address ?? ""
        self.nameLabel.text = currentFacility.nameFacility
        
        if currentFacility.nameFacility.starts(with: "A") {
            let currentUrl = URL(string: "https://cdn.20m.es/img/2007/10/03/686221.jpg")
            self.imageFacility.af_setImage(withURL: currentUrl!)
            
            let baseString = "Hoy ya hay programados 3 partidos en esta pista"
            let attributedString = NSMutableAttributedString(string: baseString, attributes: nil)
            let dontRange = (attributedString.string as NSString).range(of: "3 partidos")
             attributedString.setAttributes([NSAttributedStringKey.foregroundColor: UIColor.blue], range: dontRange)
            self.labelDescription.attributedText = attributedString
            
        }else if currentFacility.nameFacility.starts(with: "E") {
            let currentUrl = URL(string:"https://www.butarque.es/wp-content/uploads/2012/08/arton1118.jpg")
            self.imageFacility.af_setImage(withURL: currentUrl!)
            
            let baseString = "Hoy ya hay programados 5 partidos en esta pista"
            let attributedString = NSMutableAttributedString(string: baseString, attributes: nil)
            let dontRange = (attributedString.string as NSString).range(of: "5 partidos")
            attributedString.setAttributes([NSAttributedStringKey.foregroundColor: UIColor.blue], range: dontRange)
            self.labelDescription.attributedText = attributedString
            
        }else{
            let currentUrl = URL(string:"https://i.ytimg.com/vi/_330_KZLUTY/maxresdefault.jpg")
            self.imageFacility.af_setImage(withURL: currentUrl!)
            
            let baseString = "Hoy no hay aún ningún partido programado en la pista"
            let attributedString = NSMutableAttributedString(string: baseString, attributes: nil)
            let dontRange = (attributedString.string as NSString).range(of: "ningún partido")
             attributedString.setAttributes([NSAttributedStringKey.foregroundColor: UIColor.blue], range: dontRange)
            self.labelDescription.attributedText = attributedString
        }
        
        self.imageFacility.heroID  = (currentFacility.idFacility)+"_0"
    }
}
