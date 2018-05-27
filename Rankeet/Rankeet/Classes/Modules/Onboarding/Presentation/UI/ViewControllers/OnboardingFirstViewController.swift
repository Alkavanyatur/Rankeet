//
//  OnboardingFirstViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 14/2/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ViewAnimator

class OnboardingFirstViewController: RankeetViewController {
    
    @IBOutlet weak var imageIntro: UIImageView!
    @IBOutlet weak var textIntro: UILabel!
    @IBOutlet weak var descIntro: UILabel!
    
    fileprivate var onboardingFirstPresenter: OnboardingFirstPresenter?
   
    static func instantiate(navigationDelegate:OnboardingIntroNavigationDelegate) -> OnboardingFirstViewController{
        let OnboardingStoryBoard = UIStoryboard(name: "Onboarding", bundle: nil)
        let onboardingFirstViewController = OnboardingStoryBoard.instantiateViewController(withIdentifier:"onboardingFirstViewController") as! OnboardingFirstViewController
        onboardingFirstViewController.onboardingFirstPresenter = OnboardingFirstPresenter(delegate: onboardingFirstViewController,navigationDelegate:navigationDelegate)
        return onboardingFirstViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onboardingFirstPresenter?.viewDidLoad()
    }
}


//
// MARK: - GenericControllerOnboardingProtocol methods
//

extension OnboardingFirstViewController: GenericControllerOnboardingProtocol {
    func dismissActionFromNavigation(){
        self.onboardingFirstPresenter?.dismissActionFromNavigation()
    }
}

//
// MARK: - OnboardingFirstPresenterDelegate methods
//

extension OnboardingFirstViewController: OnboardingFirstPresenterDelegate {
    
    func animateViewsAppear() {
        let currentDirection = Direction.right
        let animationText = AnimationType.from(direction: currentDirection, offset: 300.0)
        let animationImage = AnimationType.from(direction: currentDirection, offset: 100.0)
        self.textIntro.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: nil)
        self.descIntro.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus2, completion: nil)
        self.imageIntro.animate(animations: [animationImage], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus) {
            self.onboardingFirstPresenter?.animationInPresentComplete()
        }
    }
    
    func animateViewsDismiss() {
        let currentDirection = Direction.left
        let animationText = AnimationType.from(direction: currentDirection, offset: 300.0)
        let animationImage = AnimationType.from(direction: currentDirection, offset: 100.0)
        self.textIntro.animate(animations: [animationText], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: nil)
        self.descIntro.animate(animations: [animationText], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus2, completion: nil)
        self.imageIntro.animate(animations: [animationImage], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus) {
            self.onboardingFirstPresenter?.animationInDismissComplete()
        }
    }
    
}


