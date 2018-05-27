//
//  MatchTableViewCell.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 27/5/18.
//  Copyright © 2018 Alejandro Hernández Matías. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWithValue(currentValue:Int){
        if currentValue == 1 {
            view1.isHidden = false
            view2.isHidden = true
        }else{
            view1.isHidden = true
            view2.isHidden = false
        }
    }
    
}
