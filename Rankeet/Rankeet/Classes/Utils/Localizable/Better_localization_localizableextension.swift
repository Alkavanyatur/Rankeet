//
//  Better_localization_localizableextension.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

public extension Localizable {
    
    public func localize(_ string: String?) -> String? {
        guard let term = string, term.hasPrefix("@") else {
            return string
        }
        guard !term.hasPrefix("@@") else {
            return String(term.dropFirst())
        }
        return NSLocalizedString(String(term.dropFirst()), comment: "")
    }
    
    public func localize(_ string: String?, _ setter: (String?) -> Void) {
        setter(localize(string))
    }
    
    public func localize(_ getter: (UIControlState) -> String?, _ setter: (String?, UIControlState) -> Void) {
        setter(localize(getter(.normal)), .normal)
        setter(localize(getter(.selected)), .selected)
        setter(localize(getter(.highlighted)), .highlighted)
        setter(localize(getter(.disabled)), .disabled)
    }
}
