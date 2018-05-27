//
//  MainStructureViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

class MainStructureViewController: UITabBarController {

    fileprivate var mainStructurePresenter: MainStructurePresenter?
    var currentTabbarIndicator:UIView?
    
    static func instantiate() -> MainStructureViewController{
        let mainstructureStoryBoard = UIStoryboard(name: "Mainstructure", bundle: nil)
        let mainStructureViewController = mainstructureStoryBoard.instantiateViewController(withIdentifier: "mainStructureViewController") as! MainStructureViewController
        mainStructureViewController.mainStructurePresenter = MainStructurePresenter(delegate: mainStructureViewController)
        return mainStructureViewController
    }
    
    //
    // MARK: - Class methods
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let currentToken = NotificationsManager().getCurrentNotificationsToken()
        
        self.prepareTabBar()
    }
    
    //
    // MARK: - Configure view methods
    //
    
    func prepareTabBar(){
        self.delegate = delegate
        
        self.configureBottomLineIndicator()
        
        let facilitiesViewController = FacilitiesViewController.instantiate()
        let navigationFacilities = UINavigationController(rootViewController: facilitiesViewController)
        navigationFacilities.isNavigationBarHidden = true
        facilitiesViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named:"icon01Unselected"), selectedImage: UIImage(named:"icon01Selected"))
        facilitiesViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -3, right: 0)
        
        let favouritesFlexibleHeaderContainerViewController = FavouritesFlexibleHeaderContainerViewController()
        let navigationFavourites = UINavigationController(rootViewController: favouritesFlexibleHeaderContainerViewController)
        favouritesFlexibleHeaderContainerViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named:"icon03Unselected"), selectedImage: UIImage(named:"icon03Selected"))
        favouritesFlexibleHeaderContainerViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -3, right: 0)
        navigationFavourites.isNavigationBarHidden = true
        
        let profileFlexibleHeaderContainerViewController = ProfileFlexibleHeaderContainerViewController()
        let navigationProfile = UINavigationController(rootViewController: profileFlexibleHeaderContainerViewController)
        profileFlexibleHeaderContainerViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named:"icon05Unselected"), selectedImage: UIImage(named:"icon05Selected"))
        profileFlexibleHeaderContainerViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -3, right: 0)
        navigationProfile.isNavigationBarHidden = true

        self.viewControllers = [navigationFacilities,navigationFavourites,navigationProfile]
        self.tabBar.tintColor = RankeetDefines.Colors.blueRan
    }
    
    func configureBottomLineIndicator(){
        self.currentTabbarIndicator = UIView(frame: CGRect(x: 0, y: self.tabBar.frame.size.height-3.0, width: DevDefines.Metrics.widhtScreen/3.0, height: 3.0))
        let insideColor:UIView = UIView(frame: CGRect(x: 10.0, y: 0.0, width: (DevDefines.Metrics.widhtScreen/3.0)-20.0, height: 3.0))
        insideColor.backgroundColor = RankeetDefines.Colors.blueRan
        insideColor.cornerRadius = 1.0
        self.currentTabbarIndicator?.addSubview(insideColor)
        self.currentTabbarIndicator?.backgroundColor = UIColor.clear
        self.tabBar.addSubview(self.currentTabbarIndicator!)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let currentIndex = tabBar.items?.index(of: item){
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
                self.currentTabbarIndicator?.frame = CGRect(x: (DevDefines.Metrics.widhtScreen/3.0)*CGFloat(currentIndex), y: self.tabBar.frame.size.height-3.0, width: DevDefines.Metrics.widhtScreen/3.0, height: 3.0)
            })
        }
    }
    
}

extension MainStructureViewController: MainStructurePresenterDelegate {
}
