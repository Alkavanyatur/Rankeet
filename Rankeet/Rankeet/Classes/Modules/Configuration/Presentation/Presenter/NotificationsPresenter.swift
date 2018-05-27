//
//  NotificationsPresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

protocol NotificationsPresenterDelegate: NSObjectProtocol {
    func showNotificationsNotAllowed()
    func showNotificationsAllowed()
}

class NotificationsPresenter: NSObject {
    private weak var delegate: NotificationsPresenterDelegate?
    private var notificationsManager : NotificationsManager!
    
    init(delegate: NotificationsPresenterDelegate) {
        self.delegate = delegate
        self.notificationsManager = NotificationsManager()
    }
    
    //
    // MARK: - public methods
    //
    func viewAppear(){
        if self.notificationsManager.isNotificationsEnabled() {
            self.delegate?.showNotificationsAllowed()
        }else{
            self.delegate?.showNotificationsNotAllowed()
        }
    }
    
    func backButtonAction(){
        self.transitionToBack()
    }
}

//
// MARK: - Transition Methods
//

extension NotificationsPresenter{
    func transitionToBack(){
        RouterManager.shared.visibleViewController?.dismiss(animated: true, completion: {
            
        })
    }
}
