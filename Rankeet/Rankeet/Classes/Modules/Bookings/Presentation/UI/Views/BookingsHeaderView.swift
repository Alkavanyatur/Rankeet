//
//  BookingsHeaderView.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ViewAnimator

class BookingsHeaderView: UIView {
    @IBOutlet weak var collapsableView: UIView!
    @IBOutlet weak var expandableLabel: UILabel!
    @IBOutlet weak var reservations: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.localize()
    }
    
    func opacityAction(currentOpacity:CGFloat){
        if self.expandableLabel.alpha == (1-currentOpacity) {
            UIView.animate(withDuration: DevDefines.Animations.mediumAnimationTime, animations: {
                self.expandableLabel.alpha = currentOpacity
            })
        }
        if self.collapsableView.alpha == currentOpacity {
            let animationText = AnimationType.from(direction: .top, offset: 50.0)
            if self.reservations.alpha == 0.0{
                self.reservations.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: {
                })
            }
            UIView.animate(withDuration: DevDefines.Animations.mediumAnimationTime, animations: {
                self.reservations.alpha = (1.0-currentOpacity)
                self.collapsableView.alpha = (1.0-currentOpacity)
            })
        }
    }
}
