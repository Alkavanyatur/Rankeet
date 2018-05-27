//
//  LocationReminderTableViewCell.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 127/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

class LocationReminderTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonAllow: UILabel!
    @IBOutlet weak var messageDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.messageDesc.text = String.facilities_no_location_reminder
        self.buttonAllow.text = String.facilities_message_location_button_yes
    }
}
