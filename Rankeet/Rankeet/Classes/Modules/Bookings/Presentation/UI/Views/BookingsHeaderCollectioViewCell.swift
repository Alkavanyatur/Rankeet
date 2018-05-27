//
//  BookingsHeaderCollectioViewCell.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

class BookingsHeaderCollectioViewCell: UICollectionViewCell {

    @IBOutlet weak var widhtCellSontraint: NSLayoutConstraint!
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.localize()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.widhtCellSontraint.constant = DevDefines.Metrics.widhtScreen
    }
    
    func configureWithSectiontitle(currentTitle:String, isActive:Bool){
        self.labelTitle.text = currentTitle
        if isActive {
            self.labelTitle.textColor = RankeetDefines.Colors.aquaBlue
        }else{
            self.labelTitle.textColor = RankeetDefines.Colors.pinkishGrey
        }
    }
}
