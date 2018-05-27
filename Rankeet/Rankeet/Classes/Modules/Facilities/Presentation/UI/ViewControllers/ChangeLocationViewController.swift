//
//  ChangeLocationViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 23/2/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import Material
import GooglePlaces

class ChangeLocationViewController: RankeetViewController {
    
    @IBOutlet weak var resultsTableView: UITableView!
    var currentLocations:[GMSAutocompletePrediction] = []
    var currentFacilities:[AlFacility] = []
    
    fileprivate var changeLocationPresenter: ChangeLocationPresenter?
    
    @IBOutlet weak var locationTextField: TextField!
    
    static func instantiate() -> ChangeLocationViewController{
        let facilitiesStoryBoard = UIStoryboard(name: "Facilities", bundle: nil)
        let changeLocationViewController = facilitiesStoryBoard.instantiateViewController(withIdentifier:"changeLocationViewController") as! ChangeLocationViewController
        changeLocationViewController.changeLocationPresenter = ChangeLocationPresenter(delegate:changeLocationViewController)
        return changeLocationViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeLocationPresenter?.requestPlacesFetcherConfiguration(controller: self)
        self.configureView()
    }
    
    //
    // MARK: - Public methods
    //
    
    @IBAction func choseUserLocation(_ sender: Any) {
        self.changeLocationPresenter?.requestUseLocationUser()
    }
    
    @IBAction func closeLocation(_ sender: Any) {
        self.changeLocationPresenter?.closeLocationScreen()
    }
    
    //
    // MARK: - Configure methods
    //
    
    func configureView(){
        self.configureSearchFied()
        self.configureResultsTable()
    }
    
    func configureSearchFied(){
        self.locationTextField.delegate = self
        self.locationTextField.isClearIconButtonEnabled = true
        self.locationTextField.clearButtonMode = .whileEditing
        self.locationTextField.textColor = RankeetDefines.Colors.aquaBlue
        self.locationTextField.placeholderNormalColor = RankeetDefines.Colors.warmGrey
        self.locationTextField.placeholderActiveColor = RankeetDefines.Colors.warmGrey
        self.locationTextField.dividerNormalColor = RankeetDefines.Colors.warmGrey
        self.locationTextField.dividerActiveColor = RankeetDefines.Colors.aquaBlue
    }
    
    func configureResultsTable(){
        self.resultsTableView.rowHeight = UITableViewAutomaticDimension
        self.resultsTableView.estimatedRowHeight = 100
        self.resultsTableView.register(UINib(nibName: "ChangeLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "ChangeLocationTableViewCell")
        self.resultsTableView.dataSource = self
        self.resultsTableView.delegate = self
    }
}

//
// MARK: - FacilitiesPresenterDelegate methods
//
extension ChangeLocationViewController: ChangeLocationPresenterDelegate {
    func loadFacilities(facilities: [AlFacility]) {
        self.currentFacilities = facilities
        self.resultsTableView.reloadData()
    }
    
    func showLoadingLocation() {
        self.showLoadingView()
    }
    
    func hideLoadingLocation(completionLoading: @escaping (Bool?) -> Void) {
        self.hideLoadingView(completionLoading: completionLoading)
    }
    
    func showMessageNoPlaceInfoError(){
        self.showAlert(message: String.change_location_error_message, title: String.generic_error, buttonCancel: String.generic_accept, buttonRight: nil) { (accept) in
            
        }
    }
}

//
// MARK: - TextFieldDelegate methods
//

extension ChangeLocationViewController: TextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString text: String) -> Bool {
        
        if text == "\n"  // Recognizes enter key in keyboard
        {
            textField.resignFirstResponder()
            return false
        }else{
            let nsString = textField.text as NSString?
            let newString = nsString?.replacingCharacters(in: range, with: text)
            if let updatedText = newString{
                self.changeLocationPresenter?.promoteChangeInSearchText(searchText: updatedText)
            }
        }
        return true
    }
}

//
// MARK: - Table view methods
//
extension ChangeLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.locationTextField.resignFirstResponder()
        if let currentText = self.locationTextField.text, currentText.isEmpty {
            self.changeLocationPresenter?.transitionToPrevScreen(currentPlace: self.changeLocationPresenter?.requestPlacesStored(currentIndex: indexPath.row))
        }else{
            if indexPath.row < self.currentFacilities.count {
                self.changeLocationPresenter?.requestAccesToDetail(currentFacility: self.currentFacilities[indexPath.row])
            }else{
                if (indexPath.row-self.currentFacilities.count) < self.currentLocations.count {
                    let currentLocationSelected = self.currentLocations[indexPath.row-self.currentFacilities.count]
                    if let currenIdPlace = currentLocationSelected.placeID {
                        self.changeLocationPresenter?.requestLocationDetail(currentPlaceId: currenIdPlace)
                    }
                }
            }
        }
    }
}


extension ChangeLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentText = self.locationTextField.text, currentText.isEmpty {
            return self.changeLocationPresenter?.requestNumPlacesStored() ?? 0
        }else{
            return self.currentFacilities.count + self.currentLocations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChangeLocationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChangeLocationTableViewCell", for: indexPath as IndexPath) as! ChangeLocationTableViewCell
        if let currentText = self.locationTextField.text, currentText.isEmpty {
            cell.configureCellWithStoredPlaceItem(storedPlace: self.changeLocationPresenter?.requestPlacesStored(currentIndex: indexPath.row), andIsLast:((self.changeLocationPresenter!.requestPlacesStoredCount() - 1)==indexPath.row))
        }else{
            if indexPath.row < self.currentFacilities.count {
                cell.configureCellWithFacility(currentFacility: self.currentFacilities[indexPath.row], andIsLast:false)
            }else{
                cell.configureCellWithGooglePlaceItem(prediction: self.currentLocations[indexPath.row-self.currentFacilities.count], andIsLast:((self.currentLocations.count - 1) == indexPath.row-self.currentFacilities.count))
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
}

//
// MARK: - GMSAutocompleteFetcherDelegate methods
//
extension ChangeLocationViewController: GMSAutocompleteFetcherDelegate {
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        self.currentLocations = predictions
        self.resultsTableView.reloadData()
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        self.currentLocations = []
        self.currentFacilities = []
        self.resultsTableView.reloadData()
    }
    
}

