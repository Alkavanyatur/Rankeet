//
//  IssuesFormViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 23/4/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import Material

class IssuesFormViewController: RankeetViewController {
    
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    
    @IBOutlet weak var labelIntro: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var textViewIssue: TextView!
    
    fileprivate var issuesFormPresenter: IssuesFormPresenter?

    static func instantiate(currentReservation:AlLightReservation) -> IssuesFormViewController{
        let BookingsStoryBoard = UIStoryboard(name: "Bookings", bundle: nil)
        let issuesFormViewController = BookingsStoryBoard.instantiateViewController(withIdentifier:"IssuesFormViewController") as! IssuesFormViewController
        issuesFormViewController.issuesFormPresenter = IssuesFormPresenter(delegate: issuesFormViewController, currentReservation: currentReservation)
        return issuesFormViewController
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.issuesFormPresenter?.backActionFromUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.issuesFormPresenter?.viewDidAppear()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var inputAccessoryView: UIView?{
        return self.createAccesoryView(title: String.issues_action)
    }
    
    //
    // MARK: - Override Beelen Controller methods
    //
    override func actionAccesoryView(_ sender: Any) {
        self.textViewIssue.resignFirstResponder()
        self.issuesFormPresenter?.uploadIssueText(currentIssue: textViewIssue.text, currentSubject: labelIntro.text!)
    }
}

extension IssuesFormViewController: IssuesFormPresenterDelegate {

    func configureView(currentReservation:AlLightReservation){
        self.textViewIssue.textContainerInsetsPreset = .square5
        self.textViewIssue.delegate = self
        
        self.backButton.setImage(Icon.arrowBack, for: .normal)
        self.backButton.tintColor = UIColor.white
        
        let currentFormatter = DateFormatter()
        currentFormatter.dateFormat = "HH:mm"
        
        if let start = currentReservation.timeStart, let end = currentReservation.timeEnd, let nameFacility = currentReservation.nameFacility {
            self.labelIntro.text = String.issues_message + " " + nameFacility + " " + String.bookings_from+" \(currentFormatter.string(from: start)) "+String.bookings_to+" \(currentFormatter.string(from: end)) h"
        }
    }
    
    func showCorrectIssue(){
        self.showAlert(message: String.issues_message_ok, title: String.issues_title, buttonCancel: String.generic_accept, buttonRight: nil) { (accept) in
            self.issuesFormPresenter?.backActionFromUser()
        }
    }
    func showErrorIssue(){
        self.showAlert(message: String.issues_message_error, title: String.issues_title_error, buttonCancel: String.generic_accept, buttonRight: nil) { (accept) in
        }
    }
    
    func showLoadingIssue(){
        self.showLoadingView()
    }
    func hideLoadingIssue(completionLoading:@escaping (Bool?) -> Void){
        self.hideLoadingView { (completion) in
            completionLoading(completion)
        }
    }
}

extension IssuesFormViewController: TextViewDelegate {
    @objc
    func handleDoneButton() {
        textViewIssue.resignFirstResponder()
    }
    
    @objc
    open func textView(textView: TextView, willShowKeyboard value: NSValue) {
        self.constraintTop.constant = -100.0
        UIView.animate(withDuration: DevDefines.Animations.shortAnimationTime) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    open func textView(textView: TextView, willHideKeyboard value: NSValue) {
        self.constraintTop.constant = 20.0
        UIView.animate(withDuration: DevDefines.Animations.shortAnimationTime) {
            self.view.layoutIfNeeded()
        }
    }
}
