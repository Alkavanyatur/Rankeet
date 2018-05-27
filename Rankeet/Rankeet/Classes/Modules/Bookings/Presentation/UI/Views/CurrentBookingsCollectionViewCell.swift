//
//  CurrentBookingsCollectionViewCell.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

protocol CurrentBookingsCollectionViewCellDelegate: NSObjectProtocol {
    func cancelAction(currentReservation:AlLightReservation)
    func turnOffAction(currentReservation:AlLightReservation)
    func extendAction(currentReservation:AlLightReservation)
}

class CurrentBookingsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var remaingTime: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var facilityNameLabel: UILabel!
    @IBOutlet weak var adress: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var offButton: UIButton!
    @IBOutlet weak var extendButton: UIButton!
    
    private weak var currentReservation:AlLightReservation!
    
    weak var delegate: CurrentBookingsCollectionViewCellDelegate?
    
    @IBOutlet weak var widhtCellSontraint: NSLayoutConstraint!
    
    @IBAction func cancelAction(_ sender: Any) {
        self.delegate?.cancelAction(currentReservation: self.currentReservation)
    }
    
    @IBAction func offAction(_ sender: Any) {
        self.delegate?.turnOffAction(currentReservation: self.currentReservation)
    }
    
    @IBAction func extendAction(_ sender: Any) {
        self.delegate?.extendAction(currentReservation: self.currentReservation)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.localize()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.widhtCellSontraint.constant = DevDefines.Metrics.widhtScreen
        
        self.cancelButton.setTitle("  "+String.bookings_cancel_action, for: .normal)
        self.offButton.setTitle("   "+String.bookings_switchof_action, for: .normal)
        self.extendButton.setTitle("  "+String.bookings_extend_action, for: .normal)
    }
    
    func configureWithLightingReservation(currentReservation:AlLightReservation){
        
        self.currentReservation = currentReservation
        self.facilityNameLabel.text = currentReservation.nameFacility
        self.adress.text = currentReservation.nameField
        
        let currentFormatter = DateFormatter()
        currentFormatter.dateFormat = "HH:mm"
        
        if let start = currentReservation.timeStart, let end = currentReservation.timeEnd {
            self.hoursLabel.text = String.bookings_from+" \(currentFormatter.string(from: start)) "+String.bookings_to+" \(currentFormatter.string(from: end)) h"
            
            if let currentState = currentReservation.state {
                switch currentState {
                case .cancelled_while, .cancelled_before, .deleted:
                    self.remaingTime.text = String.bookings_detail_state_cancelled
                default:
                    if let diffInMin = Calendar.current.dateComponents([.minute], from: Date(), to: start).minute {
                        if diffInMin > 60 {
                            let currentHour:Int = diffInMin/60
                            self.remaingTime.text = String.bookings_remains+" \(currentHour) "+String.bookings_hours+" "+String.generic_and+" \(diffInMin-(currentHour*60)) "+String.bookings_mins
                        }else{
                            if diffInMin < 0 {
                                if start < Date() && end > Date() {
                                    self.remaingTime.text = String.bookings_detail_state_in_progress
                                }else{
                                    self.remaingTime.text = String.bookings_detail_state_finished
                                }
                            }else{
                                self.remaingTime.text = String.bookings_remains+" \(diffInMin) "+String.bookings_mins
                            }
                        }
                    }
                }
            }else{
                self.remaingTime.isHidden = true
            }
            
        }else{
            self.hoursLabel.text = ""
            self.remaingTime.text = ""
        }
        
        self.cancelButton.isEnabled = true
        self.cancelButton.alpha = 1.0
        self.extendButton.isEnabled = true
        self.extendButton.alpha = 1.0
        self.offButton.isEnabled = true
        self.offButton.alpha = 1.0
        if let start = currentReservation.timeStart {
            if start > Date() {
                self.extendButton.isEnabled = false
                self.extendButton.alpha = 0.5
                self.offButton.isEnabled = false
                self.offButton.alpha = 0.5
            }else{
                self.cancelButton.isEnabled = false
                self.cancelButton.alpha = 0.5
            }
        }
    }

}
