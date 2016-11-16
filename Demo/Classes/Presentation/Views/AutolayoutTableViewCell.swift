//
//  AutolayoutTableViewCell.swift
//  TabletDemo
//
//  Created by Max Sokolov on 24/05/16.
//  Copyright © 2016 Tablet. All rights reserved.
//

import UIKit
import TableKit

private let LoremIpsumTitle = "Lorem ipsum dolor sit amet, consectetur adipisicing elit"

class AutolayoutTableViewCell: UITableViewCell, ConfigurableCell {
    
    typealias T = String
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!

    static var estimatedHeight: CGFloat? {
        return 150
    }
    
    func configure(with string: T) {
        
        titleLabel.text = LoremIpsumTitle
        subtitleLabel.text = string
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layoutIfNeeded()
        
        titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.size.width
        subtitleLabel.preferredMaxLayoutWidth = subtitleLabel.bounds.size.width
    }
}
