//
//  FacilityFeedbackViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 9/4/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ViewAnimator

class FacilityFeedbackViewController: RankeetViewController {
    
    @IBOutlet weak var imageFeedback: UIImageView!
    @IBOutlet weak var labelFeedback: UILabel!
    @IBOutlet weak var viewFeedback: UIView!
    
    fileprivate var facilityFeedbackPresenter: FacilityFeedbackPresenter?

    static func instantiate(currentNavigationDelegate:FacilityActionDelegate?) -> FacilityFeedbackViewController{
        let facilitiesStoryBoard = UIStoryboard(name: "Facilities", bundle: nil)
        let facilityFeedbackViewController = facilitiesStoryBoard.instantiateViewController(withIdentifier:"FacilityFeedbackViewController") as! FacilityFeedbackViewController
        facilityFeedbackViewController.facilityFeedbackPresenter = FacilityFeedbackPresenter(delegate: facilityFeedbackViewController,delegateNavigation:currentNavigationDelegate)
        return facilityFeedbackViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.facilityFeedbackPresenter?.viewDidLoad()
    }
}

//
// MARK: - FacilityFeedbackPresenterDelegate methods
//
extension FacilityFeedbackViewController : FacilityFeedbackPresenterDelegate {
    
    func showFeedbackInfoAnimation(){
        self.viewFeedback.animate(animations: [], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.shortAnimationTime) {
        }
        let animationText = AnimationType.from(direction: .right, offset: 150.0)
        let animationImage = AnimationType.from(direction: .right, offset: 100.0)
        self.labelFeedback.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus, completion: nil)
        self.imageFeedback.animate(animations: [animationImage], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus, completion: nil)
    }
}
