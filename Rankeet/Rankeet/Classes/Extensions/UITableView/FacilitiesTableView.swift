//
//  FacilitiesTableView.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 6/3/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

class FacilitiesTableView: UITableView {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        /// the height of the table itself.
        let height:CGFloat = self.bounds.size.height + self.contentOffset.y
        /// the bounds of the table.
        /// it's strange that the origin of the table view is actually the top-left of the table.
        let tableBounds:CGRect = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: height)
        return tableBounds.contains(point)
    }

}
