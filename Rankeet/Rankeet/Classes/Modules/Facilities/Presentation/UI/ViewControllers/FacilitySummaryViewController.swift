//
//  FacilitySummaryViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

class FacilitySummaryViewController: RankeetViewController {

    @IBOutlet weak var nameFacility: UILabel!
    @IBOutlet weak var adressFacility: UILabel!
    @IBOutlet weak var nameField: UILabel!
    
    @IBOutlet weak var fromHour: UILabel!
    @IBOutlet weak var toHour: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalAmountMoney: UILabel!
    
    @IBOutlet weak var descriptionActionLabel: UILabel!
    
    @IBOutlet weak var moreInformationButton: UIButton!
    
    private weak var facilityActionDelegate: FacilityActionDelegate?
    
     fileprivate var facilitySummaryPresenter: FacilitySummaryPresenter?
    
    static func instantiate(lightReservation:AlLightReservation?, currentNavigationDelegate:FacilityActionDelegate?) -> FacilitySummaryViewController{
        let facilitiesStoryBoard = UIStoryboard(name: "Facilities", bundle: nil)
        let facilitySummaryViewController = facilitiesStoryBoard.instantiateViewController(withIdentifier:"FacilitySummaryViewController") as! FacilitySummaryViewController
        facilitySummaryViewController.facilityActionDelegate = currentNavigationDelegate
        facilitySummaryViewController.facilitySummaryPresenter = FacilitySummaryPresenter(delegate: facilitySummaryViewController,lightReservation:lightReservation)
        return facilitySummaryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.facilitySummaryPresenter?.viewDidLoad()
    }
    
    @IBAction func moreInformationAction(_ sender: Any) {
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.facilitySummaryPresenter?.cancelAction()
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        self.facilitySummaryPresenter?.confirmAction()
    }
}

//
// MARK: - FacilitySummaryPresenterDelegate methods
//

extension FacilitySummaryViewController : FacilitySummaryPresenterDelegate {
    
    func configureBodyWithReservation(currentReservation:AlLightReservation){
        if let currentFacility = currentReservation.nameFacility {
            self.nameFacility.text = currentFacility
        }
        if let currentAdress = currentReservation.addresFacility {
            self.adressFacility.text = currentAdress
        }
        if let currentField = currentReservation.nameField {
            self.nameField.text = currentField
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if let currentTimeStart = currentReservation.timeStart {
            self.fromHour.text = formatter.string(from: currentTimeStart)
        }
        if let currentTimeEnd = currentReservation.timeEnd {
            self.toHour.text = formatter.string(from: currentTimeEnd)
        }
        self.moreInformationButton.semanticContentAttribute = .forceRightToLeft
        
        if let currentPrice = currentReservation.lightPriceField, currentPrice.count > 0, let currentPriceNumber = Int(currentPrice), currentPriceNumber > 0 {
            self.priceLabel.text = String.bookings_summary_price+" \(currentPriceNumber/100)€"
            self.totalAmountMoney.text = String.bookings_wallet_money+" - 18€"
        }else{
            self.priceLabel.text = String.bookings_free_reservation
            self.totalAmountMoney.text = ""
        }
    }
    
    func showEnjoyFeedback(){
        let facilityFeedbackViewController:FacilityFeedbackViewController = FacilityFeedbackViewController.instantiate(currentNavigationDelegate: self.facilityActionDelegate)
        facilityFeedbackViewController.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(facilityFeedbackViewController.view)
    }
    
    func showErrorMessageReservation(){
        self.showAlert(message: String.bookings_error_action_message, title: String.bookings_error_action_title, buttonCancel: String.generic_accept, buttonRight: nil) { (completion) in
        }
    }
    
    func showLoadingReservation(){
        self.showLoadingView()
    }
    
    func hideLoadingReservation(completionLoading:@escaping (Bool?) -> Void){
        self.hideLoadingView { (completion) in
            completionLoading(true)
        }
    }
}
