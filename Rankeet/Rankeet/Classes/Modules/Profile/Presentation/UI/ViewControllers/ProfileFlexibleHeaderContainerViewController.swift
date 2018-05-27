//
//  ProfileFlexibleHeaderContainerViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 226/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialFlexibleHeader
import NVActivityIndicatorView
import DynamicBlurView

class ProfileFlexibleHeaderContainerViewController: MDCFlexibleHeaderContainerViewController {
    
    var needLightStatus:Bool = true
    
    var emptyView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: DevDefines.Metrics.widhtScreen, height: DevDefines.Metrics.heightScreen))
    var blurView:DynamicBlurView?
    var indicator: NVActivityIndicatorView?
    var loginNavViewController: UINavigationController?
    
    init() {
        let profileViewController:ProfileViewController = ProfileViewController.instantiate()
        
        super.init(contentViewController: profileViewController)
        profileViewController.headerViewController = self.headerViewController
        profileViewController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.needLightStatus{
            return .lightContent
        }else{
            return .default
        }
    }
}


extension ProfileFlexibleHeaderContainerViewController:ProfileViewControllerDelegate {
    func showLoginView(){
        if self.loginNavViewController == nil {
            self.needLightStatus = false
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func hideLoginView(){
        self.needLightStatus = true
        self.setNeedsStatusBarAppearanceUpdate()
        if let currentControllerLogin = self.loginNavViewController {
            self.remove(asChildViewController: currentControllerLogin)
            self.loginNavViewController = nil
        }
        if let profileViewController = self.contentViewController as? ProfileViewController{
            
        }
    }
    
    func showLoadingProfile(){
        self.needLightStatus = false
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.emptyView.backgroundColor = UIColor.white
        if self.emptyView.superview == nil {
            self.view.addSubview(self.emptyView)
        }
        if self.blurView == nil {
            self.blurView = DynamicBlurView(frame: view.bounds)
            self.indicator = NVActivityIndicatorView(frame: CGRect(x: (self.view.frame.size.width-40)/2.0, y: (self.view.frame.size.height-40)/2.0, width: 40, height: 40), type: NVActivityIndicatorType.ballScaleMultiple, color: RankeetDefines.Colors.aquaBlue, padding: nil)
            self.blurView?.addSubview(self.indicator!)
            self.blurView?.blurRadius = 10
            self.view.addSubview(self.blurView!)
        }
        self.view.bringSubview(toFront: self.blurView!)
        self.indicator?.startAnimating()
        self.blurView?.alpha = 0.0
        self.blurView?.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView?.alpha = 1.0
        }) { (completion) in
        }
    }
    func hideLoadingProfile(completionLoading: @escaping (Bool?) -> Void){
        self.needLightStatus = true
        self.setNeedsStatusBarAppearanceUpdate()
        
        guard self.blurView != nil else {
            return
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.blurView?.alpha = 0.0
        }) { (completion) in
            self.emptyView.removeFromSuperview()
            self.indicator?.stopAnimating()
            self.blurView?.isHidden = true
            completionLoading(true)
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        // Add Child View as Subview
        view.addSubview(viewController.view)
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
}
