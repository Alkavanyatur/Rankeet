//
//  SearchFiltersViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

class SearchFiltersViewController: RankeetViewController {
    
    @IBOutlet weak var buttonsSport: UIStackView!
    @IBOutlet weak var buttonsSize: UIView!
    
    var numMaxTagsButtons = 100
    
    fileprivate var searchFiltersPresenter: SearchFiltersPresenter?
    
    static func instantiate() -> SearchFiltersViewController{
        let facilitiesStoryBoard = UIStoryboard(name: "Facilities", bundle: nil)
        let searchFiltersViewController = facilitiesStoryBoard.instantiateViewController(withIdentifier:"searchFiltersViewController") as! SearchFiltersViewController
        searchFiltersViewController.searchFiltersPresenter = SearchFiltersPresenter(delegate:searchFiltersViewController)
        return searchFiltersViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchFiltersPresenter?.viewDidAppear()
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        if let currentButton = sender as? UIButton{
            self.interactWithButton(currentButton: currentButton)
        }
    }
    
    //
    // MARK: - Configure methods
    //
    func configureButtonsState(){
        self.configureAllButtonsState(currentView: self.buttonsSport)
        self.configureAllButtonsState(currentView: self.buttonsSize)
    }
    
    //
    // MARK: - Public methods
    //
    @IBAction func closeFilters(_ sender: Any) {
        self.searchFiltersPresenter?.closeFilterScreen()
    }
    
    @IBAction func applyFilters(_ sender: Any) {
        self.searchFiltersPresenter?.applyFiltersAction()
    }
}

//
// MARK: - Button states methods
//
extension SearchFiltersViewController {
    
    func configureAllButtonsState(currentView:UIView){
        for i in 101...self.numMaxTagsButtons {
            if let currentButton = currentView.viewWithTag(i) as? UIButton{
                if currentView == self.buttonsSport {
                    if self.searchFiltersPresenter?.needToEnableSportFilter(currentFilter: i) ?? false {
                        currentButton.layer.borderWidth = 0
                        currentButton.backgroundColor = RankeetDefines.Colors.aquaBlue
                        currentButton.setTitleColor(UIColor.white, for: .normal)
                        currentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
                        currentButton.backgroundColor = RankeetDefines.Colors.aquaBlue
                        self.selectImageButtonSports(currentSuperView: currentView, currentButton: currentButton, needToSelect: true)
                    }else{
                        currentButton.layer.borderColor = RankeetDefines.Colors.clearGray.cgColor
                        currentButton.layer.borderWidth = 1
                        currentButton.setTitleColor(RankeetDefines.Colors.greyButtons, for: .normal)
                        currentButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
                        currentButton.backgroundColor = UIColor.clear
                        self.selectImageButtonSports(currentSuperView: currentView, currentButton: currentButton, needToSelect: false)
                    }
                }else if currentView == self.buttonsSize {
                    if self.searchFiltersPresenter?.needToEnableSizeFilter(currentFilter: i) ?? false {
                        currentButton.layer.borderWidth = 0
                        currentButton.setTitleColor(UIColor.white, for: .normal)
                        currentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
                        currentButton.backgroundColor = RankeetDefines.Colors.aquaBlue
                    }else{
                        currentButton.setTitleColor(RankeetDefines.Colors.greyButtons, for: .normal)
                        currentButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
                        currentButton.backgroundColor = UIColor.clear
                        currentButton.layer.borderColor = RankeetDefines.Colors.clearGray.cgColor
                        currentButton.layer.borderWidth = 1
                    }
                }
            }
        }
    }
    
    func interactWithButton(currentButton:UIButton){
        if let currentSuperview = currentButton.superview{
            if currentButton.layer.borderWidth == 1 {
                currentButton.layer.borderWidth = 0
                currentButton.setTitleColor(UIColor.white, for: .normal)
                currentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
                currentButton.backgroundColor = RankeetDefines.Colors.aquaBlue
                self.selectImageButtonSports(currentSuperView: currentSuperview, currentButton: currentButton, needToSelect: true)
            }else{
                currentButton.layer.borderWidth = 1
                currentButton.setTitleColor(RankeetDefines.Colors.greyButtons, for: .normal)
                currentButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
                currentButton.layer.borderColor = RankeetDefines.Colors.clearGray.cgColor
                currentButton.backgroundColor = UIColor.clear
                self.selectImageButtonSports(currentSuperView: currentSuperview, currentButton: currentButton, needToSelect: false)
            }
            if currentSuperview == self.buttonsSport {
                self.searchFiltersPresenter?.interactWithSportFilter(currentFilter: currentButton.tag)
            }else if currentSuperview == self.buttonsSize {
                self.searchFiltersPresenter?.interactWithsizeFilter(currentFilter:currentButton.tag)
            }
        }
    }
    
    func selectImageButtonSports(currentSuperView:UIView,currentButton:UIButton,needToSelect:Bool){
        /*if currentSuperView == self.buttonsSport {
            switch currentButton.tag {
            case 101:
                if needToSelect {
                    currentButton.setImage(UIImage(named:"futball_icon"), for: .normal)
                }else{
                    currentButton.setImage(UIImage(named:"futball_icon_unselected"), for: .normal)
                }
            case 102:
                if needToSelect {
                    currentButton.setImage(UIImage(named:"basket_icon"), for: .normal)
                }else{
                   currentButton.setImage(UIImage(named:"basket_icon_unselected"), for: .normal)
                }
            default:
                if needToSelect {
                    currentButton.setImage(UIImage(named:"others_icon"), for: .normal)
                }else{
                    currentButton.setImage(UIImage(named:"others_icon_unselected"), for: .normal)
                }
            }
        }*/
    }
}

//
// MARK: - FacilitiesPresenterDelegate methods
//
extension SearchFiltersViewController: SearchFiltersPresenterDelegate {
    func showSportsFilters(currentSports: [ConfigSports]) {
        self.numMaxTagsButtons = self.numMaxTagsButtons+currentSports.count
        self.buttonsSport.addArrangedSubview(UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 0)))
        for currentSport in currentSports {
            let currentButton:UIButton = UIButton()
            currentButton.setTitleColor(RankeetDefines.Colors.greyButtons, for: .normal)
            currentButton.layer.cornerRadius = 24.0
            currentButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
            currentButton.setTitle("    "+(currentSport.nameFilter ?? "")+"    ", for: .normal)
            currentButton.tag = currentSport.idFilter
            currentButton.addTarget(self, action: #selector(filterButtonPressed(_:)), for:.touchUpInside)
            self.buttonsSport.addArrangedSubview(currentButton)
        }
        self.buttonsSport.addArrangedSubview(UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 0)))
        self.configureButtonsState()
    }
}

