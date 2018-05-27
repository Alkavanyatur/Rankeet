//
//  NotificationsViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

class NotificationsViewController: RankeetViewController {

    @IBOutlet weak var labelNotifications: UILabel!
    @IBOutlet weak var notificationsButton: UIButton!
    
    fileprivate var notificationsPresenter: NotificationsPresenter?
    
    static func instantiate() -> NotificationsViewController{
        let configurationStoryBoard = UIStoryboard(name: "Configuration", bundle: nil)
        let notificationsViewController = configurationStoryBoard.instantiateViewController(withIdentifier:"notificationsViewController") as! NotificationsViewController
        notificationsViewController.notificationsPresenter = NotificationsPresenter(delegate: notificationsViewController)
        return notificationsViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.notificationsPresenter?.viewAppear()
        self.addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notificationsPresenter?.viewAppear()
    }
    
    //
    // MARK: - Public user methods
    //
    
    @IBAction func backAction(_ sender: Any) {
        self.notificationsPresenter?.backButtonAction()
    }
    
    @IBAction func notificationsAction(_ sender: Any) {
        if NotificationsManager.sharedInstance.needToRequestNotificationsAllowed(){
            NotificationsManager.sharedInstance.requestNotificationsAllowed()
        }
    }
    
    //
    // MARK: - Configure view methods
    //
    
    func addObservers(){
        NotificationCenter.default.addObserver(self,selector: #selector(checkNotificationsStateDelay),name: NSNotification.Name.UIApplicationDidBecomeActive,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(checkNotificationsState),name: NSNotification.Name.UIApplicationWillEnterForeground,object: UIApplication.shared)
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: UIApplication.shared)
    }
    
    @objc func checkNotificationsStateDelay(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.notificationsPresenter?.viewAppear()
        }
    }
    
    @objc func checkNotificationsState(){
        self.notificationsPresenter?.viewAppear()
    }
}

//
// MARK: - NotificationsPresenterDelegate methods
//

extension NotificationsViewController: NotificationsPresenterDelegate {
    
    func showNotificationsNotAllowed(){
        self.labelNotifications.text = "Activa las notificaciones"
        self.notificationsButton.isEnabled = true
    }
    
    func showNotificationsAllowed(){
        self.labelNotifications.text = "Las notificaciones ya han sido activadas"
        self.notificationsButton.alpha = 0.5
        self.notificationsButton.isEnabled = false
    }
}
