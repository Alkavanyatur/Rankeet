//
//  SportSelectionViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 21/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

class SportSelectionViewController: RankeetViewController {

    fileprivate var sportsSelectionPresenter: SportsSelectionPresenter?
    var currentSports:[Int] = []
    @IBOutlet weak var sportsTableView: UITableView!
    
    static func instantiate(currentFacility:AlFacility?, currentNavigationDelegate:SportsSelectionNavigationDelegate?) -> SportSelectionViewController{
        let facilitiesStoryBoard = UIStoryboard(name: "Facilities", bundle: nil)
        let sportSelectionViewController = facilitiesStoryBoard.instantiateViewController(withIdentifier:"sportSelectionViewController") as! SportSelectionViewController
        sportSelectionViewController.sportsSelectionPresenter = SportsSelectionPresenter(delegate: sportSelectionViewController, delegateNavigation: currentNavigationDelegate, currentFacility: currentFacility)
        return sportSelectionViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sportsSelectionPresenter?.viewDidLoad()
    }
    
    @IBAction func closeSports(_ sender: Any) {
        self.sportsSelectionPresenter?.cancelAction()
    }
}

extension SportSelectionViewController: SportsSelectionPresenterDelegate {
    func configureListSports(currentSports: [Int]) {
        self.currentSports = currentSports
        self.sportsTableView.reloadData()
    }
}

extension SportSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sportsSelectionPresenter?.selectSportType(currentSport: self.currentSports[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentSports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sportCell", for: indexPath as IndexPath)
        if let currentView = cell.viewWithTag(101){
            currentView.layer.cornerRadius = 23.5
            currentView.layer.borderWidth = 1
            currentView.layer.borderColor = RankeetDefines.Colors.aquaBlue.cgColor
            if let currentLabel = currentView.viewWithTag(102) as? UILabel {
                currentLabel.textColor = RankeetDefines.Colors.aquaBlue
                currentLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
                currentLabel.text = self.sportsSelectionPresenter?.getNameSportByType(currentType: self.currentSports[indexPath.row])
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
}
