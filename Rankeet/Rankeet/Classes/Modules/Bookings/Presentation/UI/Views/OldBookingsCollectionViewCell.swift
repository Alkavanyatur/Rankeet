//
//  OldBookingsCollectionViewCell.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

class OldBookingsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var facilityNameLabel: UILabel!
    @IBOutlet weak var adress: UILabel!
    
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    
    @IBOutlet weak var widhtCellSontraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.localize()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.widhtCellSontraint.constant = DevDefines.Metrics.widhtScreen
    }
    
    func configureWithLightingReservation(currentReservation:AlLightReservation, islastBooking:Bool){
        let currentFormatterDate = DateFormatter()
        currentFormatterDate.dateFormat = "dd/MM/yyyy"
        if let start = currentReservation.timeStart {
            self.dateLabel.text = currentFormatterDate.string(from: start)
        }else{
            self.dateLabel.text = ""
        }
        self.facilityNameLabel.text = currentReservation.nameFacility
        self.adress.text = currentReservation.nameField
        
        let currentFormatter = DateFormatter()
        currentFormatter.dateFormat = "HH:mm"
        
        if let start = currentReservation.timeStart, let end = currentReservation.timeEnd {
            self.hoursLabel.text = String.bookings_from+" \(currentFormatter.string(from: start)) "+String.bookings_to+" \(currentFormatter.string(from: end)) h"
        }else{
            self.hoursLabel.text = ""
        }
        if islastBooking {
            self.separator.isHidden = true
        }else{
            self.separator.isHidden = false
        }
        
        if let currentState = currentReservation.state {
            switch currentState {
            case .cancelled_while, .cancelled_before, .deleted:
                self.cancelLabel.isHidden = false
            default:
               self.cancelLabel.isHidden = true
            }
        }else{
            self.cancelLabel.isHidden = true
        }
        
    }
    

}
