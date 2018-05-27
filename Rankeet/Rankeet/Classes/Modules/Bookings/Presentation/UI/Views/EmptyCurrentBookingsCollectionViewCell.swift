//
//  EmptyCurrentBookingsCollectionViewCell.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

class EmptyCurrentBookingsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var widhtCellSontraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.localize()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.widhtCellSontraint.constant = DevDefines.Metrics.widhtScreen
    }

}
