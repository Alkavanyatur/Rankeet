//
//  RankeetViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import PopupDialog
import NVActivityIndicatorView
import DynamicBlurView

class RankeetViewController: UIViewController {
    
    var blurView:DynamicBlurView?
    var indicator: NVActivityIndicatorView?
    var accesoryView:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.localize()
        
        let dialogAppearance = PopupDialogDefaultView.appearance()
        dialogAppearance.titleFont            = .boldSystemFont(ofSize: 20)
        dialogAppearance.titleColor           = RankeetDefines.Colors.clearBlue
        dialogAppearance.titleTextAlignment   = .center
        dialogAppearance.messageFont          = .systemFont(ofSize: 14)
        dialogAppearance.messageColor         = RankeetDefines.Colors.warmGrey
        dialogAppearance.messageTextAlignment = .center
    }
}

//
// MARK: - AccesoryView methods
//

extension RankeetViewController{
    
    func createAccesoryView(title:String) -> UIView?{
        self.accesoryView = UIView(frame: CGRect(x: 0, y: DevDefines.Metrics.heightScreen-60.0, width: DevDefines.Metrics.widhtScreen, height: 60.0))
        self.accesoryView?.backgroundColor = UIColor.clear
        
        let nextButtonAccesory:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: (self.accesoryView?.frame.size.width ?? 0), height:60.0))
        nextButtonAccesory.backgroundColor = RankeetDefines.Colors.aquaBlue
        nextButtonAccesory.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        nextButtonAccesory.setTitleColor(UIColor.white, for: UIControlState.normal)
        nextButtonAccesory.setTitle(title.uppercased(), for: UIControlState.normal)
        nextButtonAccesory.addTarget(self, action: #selector(actionAccesoryView(_:)), for: UIControlEvents.touchUpInside)
        
        self.accesoryView?.addSubview(nextButtonAccesory)
        return self.accesoryView
    }
    
    @objc func actionAccesoryView(_ sender: Any) {
        
    }
}

//
// MARK: - Loading methods
//

extension RankeetViewController{
    
    func showLoadingView(){
        if let resultIndicator = self.indicator?.isAnimating, resultIndicator == true {
            return
        }
        if self.blurView == nil {
            self.blurView = DynamicBlurView(frame: view.bounds)
            self.indicator = NVActivityIndicatorView(frame: CGRect(x: (self.view.frame.size.width-40)/2.0, y: (self.view.frame.size.height-40)/2.0, width: 40, height: 40), type: NVActivityIndicatorType.ballScaleMultiple, color: RankeetDefines.Colors.aquaBlue, padding: nil)
            self.blurView?.addSubview(self.indicator!)
            self.blurView?.blurRadius = 10
            self.view.addSubview(self.blurView!)
        }
        self.indicator?.startAnimating()
        self.blurView?.alpha = 0.0
        self.blurView?.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView?.alpha = 1.0
        }) { (completion) in
        }
    }
    
    func hideLoadingView(completionLoading:@escaping (Bool?) -> Void){
        guard self.blurView != nil else {
            return
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.blurView?.alpha = 0.0
        }) { (completion) in
            self.indicator?.stopAnimating()
            self.blurView?.isHidden = true
            completionLoading(true)
        }
    }
}


//
// MARK: - Alert methods
//

extension RankeetViewController{
    
    func showAlert(message:String, title:String, buttonCancel:String, buttonRight:String?, completion:@escaping (Bool?) -> Void){
    
        let popup = PopupDialog(title: title, message: message)
        // Create buttons
        let buttonOne = CancelButton(title: buttonCancel) {
            completion(false)
        }
        // This button will not the dismiss the dialog
        if let currentButton = buttonRight{
            let buttonTwo = DefaultButton(title: currentButton, dismissOnTap: true) {
                completion(true)
            }
            popup.addButtons([buttonOne, buttonTwo])
        }else{
            popup.addButtons([buttonOne])
        }
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
}
