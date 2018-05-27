//
//  ConfigSports.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

class ConfigSports: NSObject {
    
    var idFilter:Int = 0
    var nameFilter:String?
    var valueFilter:String?
    
    init(idFilter:Int,nameFilter:String,valueFilter:String) {
        self.idFilter = idFilter
        self.nameFilter = nameFilter
        self.valueFilter = valueFilter
    }
}
