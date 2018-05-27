//
//  OnboardingSecondViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ViewAnimator

class OnboardingSecondViewController: RankeetViewController {
    
    @IBOutlet weak var imageIntro: UIImageView!
    @IBOutlet weak var textIntro: UILabel!
    @IBOutlet weak var descIntro: UILabel!

    fileprivate var onboardingSecondPresenter: OnboardingSecondPresenter?
    
     static func instantiate(navigationDelegate:OnboardingIntroNavigationDelegate) -> OnboardingSecondViewController{
        let OnboardingStoryBoard = UIStoryboard(name: "Onboarding", bundle: nil)
        let onboardingSecondViewController = OnboardingStoryBoard.instantiateViewController(withIdentifier:"onboardingSecondViewController") as! OnboardingSecondViewController
        onboardingSecondViewController.onboardingSecondPresenter = OnboardingSecondPresenter(delegate: onboardingSecondViewController,navigationDelegate:navigationDelegate)
        return onboardingSecondViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onboardingSecondPresenter?.viewDidLoad()
        
    }
    
    func noActionFromNavigation() {
        self.onboardingSecondPresenter?.declineFromUser()
    }
    func yesActionFromNavigation() {
        self.onboardingSecondPresenter?.continueFromUser()
    }
    
    func continueWithFacility(currentFacility:AlFacility){
        self.onboardingSecondPresenter?.transitionFromUserWithFacility(currentFacility: currentFacility)
    }
}

//
// MARK: - GenericControllerOnboardingProtocol methods
//

extension OnboardingSecondViewController: GenericControllerOnboardingProtocol {
    func dismissActionFromNavigation(){
        self.onboardingSecondPresenter?.dismissActionFromNavigation()
    }
}

//
// MARK: - LoginPresenterDelegate methods
//

extension OnboardingSecondViewController: OnboardingSecondPresenterDelegate {
    
    func animateViewsAppear() {
        let currentDirection = Direction.right
        let animationText = AnimationType.from(direction: currentDirection, offset: 300.0)
        let animationImage = AnimationType.from(direction: currentDirection, offset: 100.0)
        self.textIntro.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: nil)
        self.descIntro.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus2, completion: nil)
        self.imageIntro.animate(animations: [animationImage], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus) {
            self.onboardingSecondPresenter?.animationInPresentComplete()
        }
    }
    
    func animateViewsDismiss() {
        let currentDirection = Direction.left
        let animationText = AnimationType.from(direction: currentDirection, offset: 300.0)
        let animationImage = AnimationType.from(direction: currentDirection, offset: 100.0)
        self.textIntro.animate(animations: [animationText], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: nil)
        self.descIntro.animate(animations: [animationText], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus2, completion: nil)
        self.imageIntro.animate(animations: [animationImage], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus) {
            self.onboardingSecondPresenter?.animationInDismissComplete()
        }
    }
}

