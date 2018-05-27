//
//  OnboardingSelectFacilityHeaderView.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 17/4/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import Material
import ViewAnimator

protocol OnboardingSelectFacilityHeaderViewDelegate: class {
    func backFromDetailHeader()
}

class OnboardingSelectFacilityHeaderView: UIView {
    
    weak var delegate: OnboardingSelectFacilityHeaderViewDelegate?
    
    @IBOutlet weak var closeButtonExpanded: UIButton!
    @IBOutlet weak var closeButtonCollapsable: UIButton!
    
    @IBOutlet weak var collapsableView: UIView!
    @IBOutlet weak var expandableLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.localize()
        
        self.closeButtonCollapsable.setImage(Icon.arrowDownward, for: .normal)
        self.closeButtonCollapsable.tintColor = UIColor.white
        self.closeButtonCollapsable.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
        
        self.closeButtonExpanded.setImage(Icon.arrowDownward, for: .normal)
        self.closeButtonExpanded.tintColor = UIColor.white
        self.closeButtonExpanded.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
    }
    
    @objc func backAction(_ sender: Any) {
        self.delegate?.backFromDetailHeader()
    }
    
    func opacityAction(currentOpacity:CGFloat){
        if self.expandableLabel.alpha == (1-currentOpacity) {
            UIView.animate(withDuration: DevDefines.Animations.mediumAnimationTime, animations: {
                self.expandableLabel.alpha = currentOpacity
            })
        }
        if self.collapsableView.alpha == currentOpacity {
            let animationText = AnimationType.from(direction: .top, offset: 50.0)
            if self.selectLabel.alpha == 0.0{
                self.selectLabel.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: {
                })
            }
            UIView.animate(withDuration: DevDefines.Animations.mediumAnimationTime, animations: {
                self.selectLabel.alpha = (1.0-currentOpacity)
                self.collapsableView.alpha = (1.0-currentOpacity)
            })
        }
    }
}
