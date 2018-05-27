//
//  BookingsHeaderDetailView.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 20/4/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import Material

protocol BookingsHeaderDetailViewDelegate: class {
    func backFromDetailHeader()
}

class BookingsHeaderDetailView: UIView {
    
    weak var delegate: BookingsHeaderDetailViewDelegate?
    
    @IBOutlet weak var collapsableView: UIView!
    
    @IBOutlet weak var expandableLabel: UILabel!
    @IBOutlet weak var buttonExpandable: UIButton!
    @IBOutlet weak var buttonCollapsable: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.localize()
        
        self.buttonExpandable.setImage(Icon.arrowDownward, for: .normal)
        self.buttonExpandable.tintColor = UIColor.black
        
        self.buttonCollapsable.setImage(Icon.arrowDownward, for: .normal)
        self.buttonCollapsable.tintColor = UIColor.white
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.delegate?.backFromDetailHeader()
    }
    
    func opacityAction(currentOpacity:CGFloat){
        if self.expandableLabel.alpha == (1-currentOpacity) {
            UIView.animate(withDuration: DevDefines.Animations.mediumAnimationTime, animations: {
                self.expandableLabel.alpha = currentOpacity
            })
        }
        if self.collapsableView.alpha == currentOpacity {
            UIView.animate(withDuration: DevDefines.Animations.mediumAnimationTime, animations: {
                self.collapsableView.alpha = (1.0-currentOpacity)
            })
        }
    }
}
