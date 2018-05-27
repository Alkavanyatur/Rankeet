//
//  ProfileViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 24/1/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialFlexibleHeader

protocol ProfileViewControllerDelegate: NSObjectProtocol {
    func showLoadingProfile()
    func hideLoadingProfile(completionLoading: @escaping (Bool?) -> Void)
    func showLoginView()
    func hideLoginView()
}

class ProfileViewController: RankeetViewController {

    fileprivate var profilePresenter: ProfilePresenter?
    
    weak var delegate: ProfileViewControllerDelegate?
    
    @IBOutlet weak var scrollProfile: UIScrollView!
    var headerViewController: MDCFlexibleHeaderViewController!
    fileprivate var headerContentView:ProfileHeaderView!
    
    static func instantiate() -> ProfileViewController{
        let profileStoryBoard = UIStoryboard(name: "Profile", bundle: nil)
        let profileViewController = profileStoryBoard.instantiateViewController(withIdentifier:"profileViewController") as! ProfileViewController
        profileViewController.profilePresenter = ProfilePresenter(delegate: profileViewController)
        return profileViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profilePresenter?.viewDidAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sizeHeaderView()
        self.profilePresenter?.viewWillAppear()
    }
    
    @IBAction func promotionAction(_ sender: Any) {
        guard let url = URL(string: "https://www.adidas.es/training") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    //
    // MARK: - Header methods
    //
    
    func sizeHeaderView() {
        let headerView = headerViewController.headerView
        let bounds = UIScreen.main.bounds
        if bounds.size.width < bounds.size.height {
            headerView.maximumHeight = DevDefines.Metrics.HeaderView.maxSizeProfileHeader
        } else {
            headerView.maximumHeight = DevDefines.Metrics.HeaderView.minSizeProfileHeader
        }
        headerView.minimumHeight = DevDefines.Metrics.HeaderView.minSizeProfileHeader
    }
    func setupHeaderView() {
        self.loadHeaderView()
        
        let headerView = headerViewController.headerView
        headerView.trackingScrollView = self.scrollProfile
        headerView.maximumHeight = DevDefines.Metrics.HeaderView.maxSizeProfileHeader
        headerView.minimumHeight = DevDefines.Metrics.HeaderView.minSizeProfileHeader
        headerView.minMaxHeightIncludesSafeArea = false
        headerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerContentView.frame = (headerView.bounds)
        headerContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerView.addSubview(headerContentView)
    }
    func loadHeaderView() {
        if let views = Bundle.main.loadNibNamed("ProfileHeaderView", owner: self, options: nil) as? [ProfileHeaderView], views.count > 0, let currentView = views.first{
            currentView.delegate = self
            self.headerContentView = currentView
            //self.headerContentView.delegate = self
        }
    }
}

// MARK: UIScrollViewDelegate

extension ProfileViewController: ProfileHeaderViewDelegate {
    func configurationMethod() {

    }
}


// MARK: UIScrollViewDelegate

extension ProfileViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == headerViewController.headerView.trackingScrollView {
            headerViewController.headerView.trackingScrollDidScroll()
        }
        let scrollOffsetY = scrollView.contentOffset.y
        var opacity: CGFloat = 1.0
        if scrollOffsetY > -(DevDefines.Metrics.HeaderView.maxSizeProfileHeader/2.0) {
            opacity = 0
        }
        if self.headerContentView != nil {
            self.headerContentView.opacityAction(currentOpacity: opacity)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == headerViewController.headerView.trackingScrollView {
            headerViewController.headerView.trackingScrollDidEndDecelerating()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let headerView = headerViewController.headerView
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollDidEndDraggingWillDecelerate(decelerate)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let headerView = headerViewController.headerView
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollWillEndDragging(withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }
}


//
// MARK: - ProfilePresenterDelegate methods
//

extension ProfileViewController: ProfilePresenterDelegate {

    func configureHeaderView() {
        self.setupHeaderView()
    }
}
