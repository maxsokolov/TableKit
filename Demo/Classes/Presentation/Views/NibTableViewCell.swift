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
    
    static var defaultHeight: CGFloat? {
        return 100
    }
    
    func configure(with number: Int) {
        titleLabel.text = "\(number)"
    }
}