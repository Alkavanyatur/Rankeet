//
//  LauncherManager.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

class LauncherManager: NSObject {
    
    static let sharedInstance = LauncherManager()
    override init() {
        super.init()
    }
}

//
// MARK: - Notifications methods
//

extension LauncherManager {

    func deeepLinkingtoReference(reference:String?){
    }
    
    func askUserMessge(message:String?, title:String?, reference:String?){
    }
}
