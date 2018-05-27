//
//  SplashViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import Lottie
import NVActivityIndicatorView

class SplashViewController: RankeetViewController {
    
    @IBOutlet weak var splashView: UIView!
    @IBOutlet weak var indicatorSplash: NVActivityIndicatorView!
    
    fileprivate lazy var splashPresenter: SplashPresenter = SplashPresenter(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splashPresenter.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

//
// MARK: - SplashPresenterDelegate Methods
//

extension SplashViewController: SplashPresenterDelegate{
    
    func showLogoAnimation() {
        UIView.animate(withDuration: DevDefines.Animations.quickAnimationTime, animations: {
            self.indicatorSplash.alpha = 1.0
            self.splashView.alpha = 1.0
        }) { (finish) in
            if(finish){
                self.splashPresenter.requestConfigurationInfo()
                self.splashPresenter.self.animationCityEnded()
            }
        }
    }
    
    func loadingConfigurationComplete() {
        UIView.animate(withDuration: DevDefines.Animations.quickAnimationTime, animations: {
            self.indicatorSplash.alpha = 0.0
        }) { (finish) in
            if(finish){
                self.splashPresenter.requestNextStepAfterConfiguration()
            }
        }
    }
    func showLoading(){
        self.indicatorSplash.startAnimating()
        self.indicatorSplash.alpha = 1.0
    }
}
