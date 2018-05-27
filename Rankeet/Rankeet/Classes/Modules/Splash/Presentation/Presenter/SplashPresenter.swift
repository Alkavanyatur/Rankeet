//
//  SplashPresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

protocol SplashPresenterDelegate: NSObjectProtocol {
    func showLogoAnimation()
    
    func loadingConfigurationComplete()
    func showLoading()
}

class SplashPresenter: NSObject {
    
    private weak var delegate: SplashPresenterDelegate?
    private var splashManager : SplashManager!
    
    fileprivate var needOnboarding:Bool = false
    fileprivate var appVersion:String = ""
    
    fileprivate var animationEnded:Bool = false
    fileprivate var configurationEnded:Bool = false
    
    init(delegate: SplashPresenterDelegate) {
        self.delegate = delegate
        self.splashManager = SplashManager()
    }
    
    //
    // MARK: - Public methods
    //
    func viewDidLoad(){
        self.delegate?.showLoading()
        self.delegate?.showLogoAnimation()
    }
    
    func animationCityEnded(){
        self.animationEnded = true
        self.checkStateAnimationAndConfig()
    }
    
    func requestConfigurationInfo() {
        DispatchQueue.main.asyncAfter(deadline: .now() + DevDefines.Delay.delayToRemoveSplash) {
            self.splashManager.requestRemoteConfigurationValues { (needOnboarding, appVersion) in
                self.needOnboarding = needOnboarding
                self.appVersion = appVersion
                self.configurationEnded = true
                self.checkStateAnimationAndConfig()
            }
        }
    }
    
    func checkStateAnimationAndConfig(){
        if self.configurationEnded && self.animationEnded {
            self.delegate?.loadingConfigurationComplete()
        }
    }
    
    func requestNextStepAfterConfiguration() {
        if self.needOnboarding {
            self.transitionToOnBoarding()
        }else{
            self.transitionToMainStructure()
        }
    }
}

//
// MARK: - Transition Methods
//

extension SplashPresenter{
    func transitionToOnBoarding(){
        let onboardingNavigationViewController:OnboardingNavigationViewController = OnboardingNavigationViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: onboardingNavigationViewController)
        navigationController.isNavigationBarHidden = true
        RouterManager.shared.visibleViewController?.present(navigationController, animated: true, completion: {
            self.delegate?.showLoading()
        })
    }
    
    func transitionToMainStructure(){
        let mainStructureViewController:MainStructureViewController = MainStructureViewController.instantiate()
        RouterManager.shared.visibleViewController?.present(mainStructureViewController, animated: true, completion: {
        })
    }
}
