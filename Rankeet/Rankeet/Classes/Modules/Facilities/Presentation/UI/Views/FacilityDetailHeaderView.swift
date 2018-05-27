//
//  FacilityDetailHeaderView.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 19/3/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import AlamofireImage
import Material
import ViewAnimator
import FaveButton
import MaterialComponents.MaterialPageControl

protocol FacilityDetailHeaderViewDeleagte: class {
    func backFromDetailHeader()
    func hideFromDetailHeader()
}

class FacilityDetailHeaderView: UIView {
    
    @IBOutlet weak var backgroundTitle: UIView!
    @IBOutlet weak var imageFacility: UIImageView!
    weak var delegate: FacilityDetailHeaderViewDeleagte?
    fileprivate var pages = NSMutableArray()
    @IBOutlet weak var emptySpaceImage: UIImageView!
    
    @IBOutlet weak var onboardingTitle: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonBookmarks: FaveButton!
    
    @IBOutlet weak var hideButtonExtended: UIButton!
    @IBOutlet weak var hideButtonCollapsed: UIButton!
    
    @IBOutlet weak var favPlaceHolder: UIImageView!

    var currentFacility: AlFacility!
    
    @IBOutlet weak var pageImagesScrollView: UIScrollView!
    
    var fromOnboarding: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.localize()
        
        buttonBack.setImage(Icon.arrowBack, for: .normal)
        buttonBack.tintColor = UIColor.white
        buttonBack.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
    }
    
    @IBAction func bookmarksAction(_ sender: Any) {
        if FavouritesManager().isFacilityFavourite(currentFacility: self.currentFacility){
            FavouritesManager().removeFacilityFavourite(currentFacility: self.currentFacility)
        }else{
            FavouritesManager().addFacilityFavourite(currentFacility: self.currentFacility)
        }
    }
    
    @objc func backAction(_ sender: Any) {
        self.delegate?.backFromDetailHeader()
    }
    @IBAction func hideAction(_ sender: Any) {
        self.delegate?.hideFromDetailHeader()
    }
    
    func configureWithFacility(currentFacility:AlFacility, fromOnboarding:Bool){
        self.currentFacility = currentFacility
        self.labelTitle.text = currentFacility.nameFacility
        
        self.emptySpaceImage.image = UIImage(named: "imgCardEmptyspaceFootball")
        if let currentFields = currentFacility.fields {
            for currentField in currentFields {
                if FacilitiesManager().isBasketSportField(currentId: currentField.typeField) {
                    self.emptySpaceImage.image = UIImage(named: "imgCardEmptyspaceBasket")
                }
            }
        }
        self.fromOnboarding = fromOnboarding
        if fromOnboarding {
            self.emptySpaceImage.isHidden = true
            self.favPlaceHolder.isHidden = true
            self.buttonBookmarks.isHidden = true
            self.pageImagesScrollView.isHidden = true
        }else{
            self.hideButtonExtended.isHidden = true
            self.hideButtonCollapsed.isHidden = true
            
            self.onboardingTitle.isHidden = true
            
            if FavouritesManager().isFacilityFavourite(currentFacility: currentFacility){
                self.buttonBookmarks.setSelected(selected: true, animated: false)
            }else{
                self.buttonBookmarks.setSelected(selected: false, animated: false)
            }
            self.buttonBookmarks.heroID = (currentFacility.idFacility)+"_bookmarks"
            self.favPlaceHolder.heroID = (currentFacility.idFacility)+"_bookmarks_place"
            self.emptySpaceImage.heroID = (currentFacility.idFacility)+"_empty_image"
            
            self.imageFacility.heroID  = (currentFacility.idFacility)+"_0"
            
            if currentFacility.nameFacility.starts(with: "A") {
                let currentUrl = URL(string: "https://cdn.20m.es/img/2007/10/03/686221.jpg")
                self.imageFacility.af_setImage(withURL: currentUrl!)
            }else if currentFacility.nameFacility.starts(with: "E") {
                let currentUrl = URL(string:"https://www.butarque.es/wp-content/uploads/2012/08/arton1118.jpg")
                self.imageFacility.af_setImage(withURL: currentUrl!)
            }else{
                let currentUrl = URL(string:"https://i.ytimg.com/vi/_330_KZLUTY/maxresdefault.jpg")
                self.imageFacility.af_setImage(withURL: currentUrl!)
            }
        }
    }
    
    func opacityAction(currentOpacity:CGFloat){
        
        if self.emptySpaceImage.alpha == (1-currentOpacity) {
            UIView.animate(withDuration: DevDefines.Animations.mediumAnimationTime, animations: {
                self.pageImagesScrollView.alpha = currentOpacity
                self.emptySpaceImage.alpha = currentOpacity
                self.onboardingTitle.alpha = currentOpacity
                self.hideButtonExtended.alpha = currentOpacity
            })
        }
        if self.backgroundView.alpha == currentOpacity {
            let animationText = AnimationType.from(direction: .top, offset: 50.0)
            if self.labelTitle.alpha == 0.0{
                self.labelTitle.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: {
                })
            }
            
            UIView.animate(withDuration: DevDefines.Animations.mediumAnimationTime, animations: {
                self.backgroundTitle.alpha  = (1.0-currentOpacity)
                self.labelTitle.alpha = (1.0-currentOpacity)
                self.backgroundView.alpha = (1.0-currentOpacity)
                self.hideButtonCollapsed.alpha = (1.0-currentOpacity)
            })
        }
    }
}

extension FacilityDetailHeaderView : UIScrollViewDelegate{
    
    @objc func didChangePage(_ sender: MDCPageControl) {
        var offset = pageImagesScrollView.contentOffset
        offset.x = CGFloat(sender.currentPage) * pageImagesScrollView.bounds.size.width
        pageImagesScrollView.setContentOffset(offset, animated: true)
    }
}
