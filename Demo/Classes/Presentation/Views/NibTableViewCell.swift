//
//  NibTableViewCell.swift
//  TableKitDemo
//
//  Created by Max Sokolov on 18/06/16.
//  Copyright © 2016 Tablet. All rights reserved.
//

import UIKit
import TableKit

class NibTableViewCell: UITableViewCell, ConfigurableCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with number: Int, isPrototype: Bool) {
        titleLabel.text = "\(number)"
    }
    
    static func defaultHeight() -> CGFloat? {
        return 100
    }
}