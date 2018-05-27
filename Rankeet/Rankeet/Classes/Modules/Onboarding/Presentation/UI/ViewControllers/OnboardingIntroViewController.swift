//
//  OnboardingIntroViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ViewAnimator

class OnboardingIntroViewController: RankeetViewController {

    @IBOutlet weak var imageIntro: UIImageView!
    @IBOutlet weak var textIntro: UILabel!
    @IBOutlet weak var descIntro: UILabel!
    
    fileprivate var onboardingIntroPresenter: OnboardingIntroPresenter?
    
    static func instantiate(navigationDelegate:OnboardingIntroNavigationDelegate) -> OnboardingIntroViewController{
        let OnboardingStoryBoard = UIStoryboard(name: "Onboarding", bundle: nil)
        let onboardingIntroViewController = OnboardingStoryBoard.instantiateViewController(withIdentifier:"onboardingIntroViewController") as! OnboardingIntroViewController
        onboardingIntroViewController.onboardingIntroPresenter = OnboardingIntroPresenter(delegate: onboardingIntroViewController,navigationDelegate:navigationDelegate)
        return onboardingIntroViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onboardingIntroPresenter?.viewDidLoad()
    }
}

//
// MARK: - GenericControllerOnboardingProtocol methods
//

extension OnboardingIntroViewController: GenericControllerOnboardingProtocol {
    func dismissActionFromNavigation(){
        self.onboardingIntroPresenter?.dismissActionFromNavigation()
    }
}

//
// MARK: - OnboardingIntroPresenterDelegate methods
//

extension OnboardingIntroViewController: OnboardingIntroPresenterDelegate {
    
    func animateViewsAppear() {
        let currentDirection = Direction.right
        let animationText = AnimationType.from(direction: currentDirection, offset: 300.0)
        let animationImage = AnimationType.from(direction: currentDirection, offset: 100.0)
        self.textIntro.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: nil)
        self.descIntro.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus2, completion: nil)
        self.imageIntro.animate(animations: [animationImage], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus) {
            self.onboardingIntroPresenter?.animationInPresentComplete()
        }
    }
    
    func animateViewsDismiss() {
        let currentDirection = Direction.left
        let animationText = AnimationType.from(direction: currentDirection, offset: 300.0)
        let animationImage = AnimationType.from(direction: currentDirection, offset: 100.0)
        self.textIntro.animate(animations: [animationText], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: nil)
        self.descIntro.animate(animations: [animationText], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus2, completion: nil)
        self.imageIntro.animate(animations: [animationImage], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus) {
            self.onboardingIntroPresenter?.animationInDismissComplete()
        }
    }
    
}

