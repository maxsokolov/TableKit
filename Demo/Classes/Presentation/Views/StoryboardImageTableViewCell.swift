//
//  StoryboardImageTableViewCell.swift
//  TabletDemo
//
//  Created by Max Sokolov on 24/05/16.
//  Copyright © 2016 Tablet. All rights reserved.
//

import UIKit
import TableKit

class StoryboardImageTableViewCell: UITableViewCell, ConfigurableCell {
    
    typealias T = String
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var customImageView: UIImageView!
    
    func configure(string: T, isPrototype: Bool) {
        
        titleLabel.text = string
        subtitleLabel.text = "Copyright © 2016 Tablet. All rights reserved.Copyright © 2016 Tablet. All rights reserved.Copyright © 2016 Tablet. All rights reserved.Copyright © 2016 Tablet. All rights reserved.Copyright © 2016 Tablet. All rights reserved.Copyright © 2016 Tablet. All rights reserved.Copyright © 2016 Tablet. All rights reserved.Copyright © 2016 Tablet. All rights reserved.Copyright © 2016 Tablet. All rights reserved.Copyright © 2016 Tablet. All rights reserved.Copyright © 2016 Tablet. All rights reserved.1"
    }
    
    static func estimatedHeight() -> CGFloat {
        return 500
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layoutIfNeeded()
        subtitleLabel.preferredMaxLayoutWidth = subtitleLabel.bounds.size.width
    }
}