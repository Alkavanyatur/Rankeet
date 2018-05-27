//
//  MainStructurePresenter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

protocol MainStructurePresenterDelegate: NSObjectProtocol {
}

class MainStructurePresenter: NSObject {
    
    private weak var delegate: MainStructurePresenterDelegate?
    
    init(delegate: MainStructurePresenterDelegate) {
        self.delegate = delegate
    }
}
