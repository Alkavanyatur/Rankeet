//
//  OnboardingNFCAcceptViewController.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Alejandro Hernández Matías. All rights reserved.
//

import UIKit
import AVFoundation

class OnboardingNFCAcceptViewController: RankeetViewController {

    @IBOutlet weak var startPlayButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    
    var player: AVAudioPlayer?
    var delegateNav: OnboardingNavigationViewControllerNFCOK?
    var currentNameGoal: String = ""
    
    @IBOutlet weak var acceptImag: UIImageView!
    
    @IBAction func startPlaying(_ sender: Any) {
        self.delegateNav?.dismissFromNFC()
    }
    
    static func instantiate(currentResult:String, currentDelegate: OnboardingNavigationViewControllerNFCOK) -> OnboardingNFCAcceptViewController{
        let OnboardingStoryBoard = UIStoryboard(name: "Onboarding", bundle: nil)
        let onboardingNFCAcceptViewController = OnboardingStoryBoard.instantiateViewController(withIdentifier:"onboardingNFCAcceptViewController") as! OnboardingNFCAcceptViewController
        onboardingNFCAcceptViewController.delegateNav = currentDelegate
        onboardingNFCAcceptViewController.currentNameGoal = currentResult
        return onboardingNFCAcceptViewController
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playSound()
        
        let baseString = "LOCALIZADO CORRECTAMENTE EN EL EQUIPO DE LA PORTERÍA \(self.currentNameGoal)"
        let attributedString = NSMutableAttributedString(string: baseString, attributes: nil)
        let dontRange = (attributedString.string as NSString).range(of: "LA PORTERÍA \(self.currentNameGoal)")
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], range: dontRange)
        self.descLabel.attributedText = attributedString
        
        self.acceptImag.loadGif(name: "animat-checkmark-color")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.startPlayButton.setTitle("Empezar a jugar", for: .normal)
        }
    }

    func playSound() {
        guard let url = Bundle.main.url(forResource: "mario_bros_vida", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }

}
