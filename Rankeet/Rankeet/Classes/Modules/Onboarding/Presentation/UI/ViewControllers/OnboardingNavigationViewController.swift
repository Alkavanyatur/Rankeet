//
//  OnboardingNavigationViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ViewAnimator
import NVActivityIndicatorView

public protocol OnboardingNavigationViewControllerNFCOK {
    func dismissFromNFC()
}

class OnboardingNavigationViewController: RankeetViewController {
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var ViewYesOrNo: UIView!
    @IBOutlet weak var viewFirstContinue: UIView!
    @IBOutlet weak var contentView: UIView!
    
    fileprivate var onboardingNavigationPresenter: OnboardingNavigationPresenter?
    fileprivate var currentIntroController: GenericControllerOnboardingProtocol?
    fileprivate var prevIntroController: GenericControllerOnboardingProtocol?
    
    static func instantiate() -> OnboardingNavigationViewController{
        let OnboardingStoryBoard = UIStoryboard(name: "Onboarding", bundle: nil)
        let onboardingNavigationViewController = OnboardingStoryBoard.instantiateViewController(withIdentifier:"onboardingNavigationViewController") as! OnboardingNavigationViewController
        onboardingNavigationViewController.onboardingNavigationPresenter = OnboardingNavigationPresenter(delegate: onboardingNavigationViewController)
        return onboardingNavigationViewController
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onboardingNavigationPresenter?.viewDidLoad()
    }

    @IBAction func dismissAction(_ sender: Any) {
        self.onboardingNavigationPresenter?.dismissFromUser()
    }
    @IBAction func continueAction(_ sender: Any) {
        if let currentValue = self.onboardingNavigationPresenter?.areButtonsEnabled(), currentValue == true{
            self.onboardingNavigationPresenter?.continueFromUser(currentFacility: nil)
        }
    }
    @IBAction func yesAction(_ sender: Any) {
        if let currentValue = self.onboardingNavigationPresenter?.areButtonsEnabled(), currentValue == true{
            
            if let currentController:OnboardingSecondViewController = self.currentIntroController as? OnboardingSecondViewController{
                currentController.yesActionFromNavigation()
            }else if let currentController:OnboardingThirdViewController = self.currentIntroController as? OnboardingThirdViewController{
                currentController.yesActionFromNavigation()
            }else{
                self.onboardingNavigationPresenter?.continueFromUser(currentFacility: nil)
            }
        }
    }
    @IBAction func noAction(_ sender: Any) {
        if let currentValue = self.onboardingNavigationPresenter?.areButtonsEnabled(), currentValue == true{
            if let currentController:OnboardingSecondViewController = self.currentIntroController as? OnboardingSecondViewController{
                currentController.noActionFromNavigation()
            }else if let currentController:OnboardingThirdViewController = self.currentIntroController as? OnboardingThirdViewController{
                currentController.noActionFromNavigation()
            }else{
                 self.onboardingNavigationPresenter?.dismissFromUser()
            }
        }
    }
}

extension OnboardingNavigationViewController : OnboardingNavigationViewControllerNFCOK{
    func dismissFromNFC() {
        self.onboardingNavigationPresenter?.dismissFromUser()
    }
}

extension OnboardingNavigationViewController : OnboardingNavigationPresenterDelegate{
    
    func reloadOnboardingWithFacility(facility:AlFacility){
        if let controller = self.currentIntroController as? OnboardingThirdViewController {
            controller.configureWithFacility(currentFacility:facility)
        }else if let controller = self.currentIntroController as? OnboardingSecondViewController {
            controller.continueWithFacility(currentFacility: facility)
        }
    }
    
    func presentOnboardingControllerStep(currentNumber:Int,facilitiy:AlFacility?){
        self.onboardingNavigationPresenter?.disableButtons()
        
        switch currentNumber {
        case 1:
            self.currentIntroController = OnboardingIntroViewController.instantiate(navigationDelegate: self)
            break
        case 2:
            self.currentIntroController = OnboardingFirstViewController.instantiate(navigationDelegate: self)
            break
        case 3:
            self.currentIntroController = OnboardingSecondViewController.instantiate(navigationDelegate: self)
            break
        case 4:
            if let currentFacility = facilitiy{
                self.currentIntroController = OnboardingThirdViewController.instantiate(currentFacility: currentFacility, navigationDelegate: self)
            }
            break
        case 5:
            self.currentIntroController = OnboardingNFCViewController.instantiate(navigationDelegate: self)
            break
        default:
            break
        }
        if let currentViewController = self.currentIntroController as? UIViewController{
            currentViewController.view.frame = CGRect(x:0,y:0,width:DevDefines.Metrics.widhtScreen,height:DevDefines.Metrics.heightScreen)
            self.contentView.addSubview(currentViewController.view)
        }
        if let prevController = self.prevIntroController{
            prevController.dismissActionFromNavigation()
        }
    }
    
    func changeButtonStepCurrentStep(currentNumber:Int){
        switch currentNumber {
        case 1:
            self.ViewYesOrNo.isHidden = true
            self.viewFirstContinue.isHidden = false
            break;
        case 2:
            self.showYesAndNotView()
            self.hideContinueView()
            break;
        case 5:
            self.hideYesAndNotView()
            break;
        default:
            self.showYesAndNotViewOnlyAlpha()
            break;
        }
        
    }
    
    func setStepIndicator(currentNumber:Int){
        self.progressViewConstraint  = self.progressViewConstraint.setMultiplier(multiplier:CGFloat(currentNumber)/CGFloat(DevDefines.Onboarding.numSteps))
        self.progressView.layoutIfNeeded()
    }
    
    // MARK: - Private methods
    func showYesAndNotView(){
        self.ViewYesOrNo.isHidden = false
        let currentDirection = Direction.bottom
        let animationText = AnimationType.from(direction: currentDirection, offset: 100.0)
        self.ViewYesOrNo.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: nil)
    }
    
    func hideYesAndNotView(){
        self.ViewYesOrNo.isHidden = false
        let currentDirection = Direction.bottom
        let animationText = AnimationType.from(direction: currentDirection, offset: 100.0)
        self.ViewYesOrNo.animate(animations: [animationText], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: nil)
        
        self.activityIndicatorView.startAnimating()
        self.activityIndicatorView.isHidden = false
        self.activityIndicatorView.alpha = 1.0
        self.activityIndicatorView.animate(animations: [animationText], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime, completion: nil)
    }
    
    func showYesAndNotViewOnlyAlpha(){
        self.ViewYesOrNo.isHidden = false
        let currentDirection = Direction.bottom
        let animationText = AnimationType.from(direction: currentDirection, offset: 0.0)
        self.ViewYesOrNo.animate(animations: [animationText], reversed: false, initialAlpha: 1.0, finalAlpha: 0.3, delay: 0.0, duration: DevDefines.Animations.quickAnimationTime) {
            self.ViewYesOrNo.animate(animations: [animationText], reversed: false, initialAlpha: 0.3, finalAlpha: 1.0, delay: 0.0, duration: DevDefines.Animations.quickAnimationTime) {
            }
        }
    }
    
    func hideContinueView(){
        let currentDirection = Direction.bottom
        let animationText = AnimationType.from(direction: currentDirection, offset: 100.0)
        self.viewFirstContinue.animate(animations: [animationText], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, delay: 0.0, duration: DevDefines.Animations.mediumAnimationTime) {
            self.viewFirstContinue.isHidden = true
        }
    }
}

//
// MARK: - OnboardingIntroNavigationDelegate methods
//

extension OnboardingNavigationViewController: OnboardingIntroNavigationDelegate {
    
    func animationPresentComplete() {
        if self.prevIntroController == nil{
            self.prevIntroController = self.currentIntroController
        }
        self.onboardingNavigationPresenter?.enableButtons()
    }
    
    func errorAndHide(){
        self.onboardingNavigationPresenter?.dismissFromUser()
    }
    
    func showCorrectMessageNFC(currentName:String){
        let onboardingNFCAcceptViewController:OnboardingNFCAcceptViewController = OnboardingNFCAcceptViewController.instantiate(currentResult: currentName, currentDelegate: self)
        RouterManager.shared.visibleViewController?.present(onboardingNFCAcceptViewController, animated: true, completion: nil)
    }
    
    func animationDismissComplete() {
        if let prevController = self.prevIntroController as? UIViewController{
            prevController.view.removeFromSuperview()
        }
        self.prevIntroController = self.currentIntroController
    }
    
    func goToNextStepFromInteralAction(){
        self.onboardingNavigationPresenter?.continueFromUser(currentFacility: nil)
    }
    
    func showLoading(){
        self.showLoadingView()
    }
    func hideLoading(completionLoading: @escaping (Bool?) -> Void){
        self.hideLoadingView(completionLoading: completionLoading)
    }
    func showMessageNoFacilitiesInfoError(){
        self.showAlert(message: String.facilities_error_message, title: String.generic_error, buttonCancel: String.generic_accept, buttonRight: nil) { (accept) in
            self.onboardingNavigationPresenter?.dismissFromUser()
        }
    }
    
    func transitionToNextOnboarding(facilitiy:AlFacility){
        self.onboardingNavigationPresenter?.continueFromUser(currentFacility: facilitiy)
    }
    
    func transitionToSelectPlaceManually(){
        self.onboardingNavigationPresenter?.transitionToSelectPlaceManually()
    }
    
    func transitionToFacilityDetail(facility:AlFacility){
        self.onboardingNavigationPresenter?.transitionToFacilityDetail(facility: facility)
    }
}

