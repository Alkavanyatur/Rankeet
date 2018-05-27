//
//  FacilityDetailFieldView.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 2/4/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

protocol FacilityDetailFieldViewDelegate: class {
    func actionFromField(currentField:AlField?)
}

class FacilityDetailFieldView: UIView {

    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var stateField: UILabel!
    @IBOutlet weak var imageField: UIImageView!
    
    @IBOutlet weak var contentView: UIView!
    public weak var currentField: AlField?
    
    weak var delegate: FacilityDetailFieldViewDelegate?
    
    @IBAction func buttonAction(_ sender: Any) {
        self.delegate?.actionFromField(currentField: self.currentField)
    }
}
