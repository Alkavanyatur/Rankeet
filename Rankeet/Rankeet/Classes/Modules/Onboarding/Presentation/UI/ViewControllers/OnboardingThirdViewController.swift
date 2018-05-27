//
//  OnboardingThirdViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ViewAnimator

class OnboardingThirdViewController: RankeetViewController {
    
    @IBOutlet weak var imageIntro: UIImageView!
    @IBOutlet weak var textIntro: UILabel!
    
    @IBOutlet weak var nameFacility: UILabel!
    @IBOutlet weak var adressFacility: UILabel!
    
    fileprivate var onboardingThirdPresenter: OnboardingThirdPresenter?
    
    static func instantiate(currentFacility:AlFacility,navigationDelegate:OnboardingIntroNavigationDelegate) -> OnboardingThirdViewController{
        let OnboardingStoryBoard = UIStoryboard(name: "Onboarding", bundle: nil)
        let onboardingThirdViewController = OnboardingStoryBoard.instantiateViewController(withIdentifier:"onboardingThirdViewController") as! OnboardingThirdViewController
        onboardingThirdViewController.onboardingThirdPresenter = OnboardingThirdPresenter(delegate: onboardingThirdViewController,currentFacility:currentFacility,navigationDelegate:navigationDelegate)
        return onboardingThirdViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onboardingThirdPresenter?.viewDidLoad()
    }
    
    func noActionFromNavigation() {
        self.onboardingThirdPresenter?.declineFromUser()
    }
    
    func yesActionFromNavigation() {
        self.onboardingThirdPresenter?.continueFromUser()
    }
}

//
// MARK: - GenericControllerOnboardingProtocol methods
//

extension OnboardingThirdViewController: GenericControllerOnboardingProtocol {
    func dismissActionFromNavigation(){
        self.onboardingThirdPresenter?.dismissActionFromNavigation()
    }
}

//
// MARK: - OnboardingThirdPresenterDelegate methods
//

extension OnboardingThirdViewController: OnboardingThirdPresenterDelegate {
    
    func configureWithFacility(currentFacility: AlFacility) {
        self.nameFacility.text = currentFacility.nameFacility
        self.nameFacility.heroID = (currentFacility.idFacility)+"_name"
        
        self.adressFacility.text = currentFacility.info?.address ?? ""
    }
    
    func animateViewsAppear() {
        let currentDirection = Direction.right
        let animationText = AnimationType.from(direction: currentDirection, offset: 300.0)
        let animationImage = AnimationType.from(direction: currentDirection, offset: 100.0)
        self.textIntro.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: nil)
        self.nameFacility.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus2, completion: nil)
        self.adressFacility.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus, completion: nil)
        self.imageIntro.animate(animations: [animationImage], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus) {
            self.onboardingThirdPresenter?.animationInPresentComplete()
        }
    }
    
    func animateViewsDismiss() {
        let currentDirection = Direction.left
        let animationText = AnimationType.from(direction: currentDirection, offset: 300.0)
        let animationImage = AnimationType.from(direction: currentDirection, offset: 100.0)
        self.textIntro.animate(animations: [animationText], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: nil)
        self.nameFacility.animate(animations: [animationText], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus2, completion: nil)
        self.adressFacility.animate(animations: [animationText], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus, completion: nil)
        self.imageIntro.animate(animations: [animationImage], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus) {
            self.onboardingThirdPresenter?.animationInDismissComplete()
        }
    }
}
