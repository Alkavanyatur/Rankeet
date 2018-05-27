//
//  ProfilePresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 24/1/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit


protocol ProfilePresenterDelegate: NSObjectProtocol {
    func configureHeaderView()
}

class ProfilePresenter: NSObject {
    private weak var delegate: ProfilePresenterDelegate?
    private var profileManager : ProfileManager!

    private var firstRequestView : Bool = true
    
    init(delegate: ProfilePresenterDelegate) {
        super.init()
        
        self.delegate = delegate
        self.profileManager = ProfileManager()
    }
    //
    // MARK: - public methods
    //

    //
    // MARK: - Public methods
    //
    func viewDidAppear(){
        self.delegate?.configureHeaderView()
    }
    
    func viewWillAppear(){
        self.checkUserState()
    }
    
    func checkUserState(){
    }
    
}


//
// MARK: - Transition Methods
//

extension ProfilePresenter{
    func transitionToLogin(){
    }
}
