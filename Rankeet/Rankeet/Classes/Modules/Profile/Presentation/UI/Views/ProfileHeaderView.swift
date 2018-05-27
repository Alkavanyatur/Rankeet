//
//  ProfileHeaderView.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 226/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ViewAnimator

protocol ProfileHeaderViewDelegate: NSObjectProtocol {
    func configurationMethod()
}

class ProfileHeaderView: UIView {
    weak var delegate: ProfileHeaderViewDelegate?
    
    @IBOutlet weak var nameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTopConstraintCollapsable: NSLayoutConstraint!
    
    @IBOutlet weak var imageUserCollapsable: UIImageView!
    @IBOutlet weak var nameUserCollapsable: UILabel!
    @IBOutlet weak var emailUserCollapsable: UILabel!
    
    @IBOutlet weak var nameUserExpandable: UILabel!
    @IBOutlet weak var emailUserExpandable: UILabel!
    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var energyLabel: UILabel!
    
    @IBOutlet weak var collapsableView: UIView!
    @IBOutlet weak var expandableView: UIView!
    
    @IBAction func configurationAction(_ sender: Any) {
        self.delegate?.configurationMethod()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.localize()
    }
    
    func opacityAction(currentOpacity:CGFloat){
        if self.expandableView.alpha == (1-currentOpacity) {
            UIView.animate(withDuration: DevDefines.Animations.mediumAnimationTime, animations: {
                self.expandableView.alpha = currentOpacity
            })
        }
        if self.collapsableView.alpha == currentOpacity {
            let animationText = AnimationType.from(direction: .top, offset: 50.0)
            if self.imageUserCollapsable.alpha == 0.0{
                self.imageUserCollapsable.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: {
                })
                self.nameUserCollapsable.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: {
                })
                self.emailUserCollapsable.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: {
                })
            }
            UIView.animate(withDuration: DevDefines.Animations.mediumAnimationTime, animations: {
                self.imageUserCollapsable.alpha = (1.0-currentOpacity)
                self.nameUserCollapsable.alpha = (1.0-currentOpacity)
                self.emailUserCollapsable.alpha = (1.0-currentOpacity)
                self.collapsableView.alpha = (1.0-currentOpacity)
            })
        }
    }
}

