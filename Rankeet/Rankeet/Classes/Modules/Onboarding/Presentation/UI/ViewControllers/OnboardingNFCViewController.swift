//
//  OnboardingNFCViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Alejandro Hernández Matías. All rights reserved.
//

import UIKit
import ViewAnimator
import CoreNFC

class OnboardingNFCViewController: RankeetViewController, NFCNDEFReaderSessionDelegate {
    
    @IBOutlet weak var imageIntro: UIImageView!
    @IBOutlet weak var textIntro: UILabel!
    @IBOutlet weak var descIntro: UILabel!
    
    private var navigationDelegate: OnboardingIntroNavigationDelegate?
    
    var nfcSession: NFCNDEFReaderSession?
    
    static func instantiate(navigationDelegate:OnboardingIntroNavigationDelegate) -> OnboardingNFCViewController{
        let OnboardingStoryBoard = UIStoryboard(name: "Onboarding", bundle: nil)
        let onboardingNFCViewController = OnboardingStoryBoard.instantiateViewController(withIdentifier:"onboardingNFCViewController") as! OnboardingNFCViewController
        onboardingNFCViewController.navigationDelegate = navigationDelegate
        return onboardingNFCViewController
    }
    
    override func viewDidLoad() {
        self.animateViewsAppear()
    }
    
    func animateViewsAppear() {
        let currentDirection = Direction.right
        let animationText = AnimationType.from(direction: currentDirection, offset: 300.0)
        let animationImage = AnimationType.from(direction: currentDirection, offset: 100.0)
        self.textIntro.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: nil)
        self.descIntro.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus2, completion: nil)
        self.imageIntro.animate(animations: [animationImage], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                self.startScanningGoals()
            }
        }
    }
    
    func animateViewsDismiss() {
        let currentDirection = Direction.left
        let animationText = AnimationType.from(direction: currentDirection, offset: 300.0)
        let animationImage = AnimationType.from(direction: currentDirection, offset: 100.0)
        self.textIntro.animate(animations: [animationText], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: nil)
        self.descIntro.animate(animations: [animationText], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus2, completion: nil)
        self.imageIntro.animate(animations: [animationImage], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTimePlus) {
            self.navigationDelegate?.animationDismissComplete()
        }
    }
    
    func startScanningGoals(){
        nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        //self.navigationDelegate?.errorAndHide()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var result = ""
        for payload in messages[0].records {
            result += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8)! // 1
        }
        self.navigationDelegate?.showCorrectMessageNFC(currentName: result)
    }
}

//
// MARK: - GenericControllerOnboardingProtocol methods
//

extension OnboardingNFCViewController: GenericControllerOnboardingProtocol {
    func dismissActionFromNavigation(){
        self.animateViewsDismiss()
    }
}

