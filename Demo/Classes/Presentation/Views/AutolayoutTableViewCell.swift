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
private let LoremIpsumBody = "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eius adipisci, sed libero. Iste asperiores suscipit, consequatur debitis animi impedit numquam facilis iusto porro labore dolorem, maxime magni incidunt. Delectus, est! Totam at eius excepturi deleniti sed, error repellat itaque omnis maiores tempora ratione dolor velit minus porro aspernatur repudiandae labore quas adipisci esse, nulla tempore voluptatibus cupiditate. Ab provident, atque. Possimus deserunt nisi perferendis, consequuntur odio et aperiam, est, dicta dolor itaque sunt laborum, magni qui optio illum dolore laudantium similique harum. Eveniet quis, libero eligendi delectus repellendus repudiandae ipsum? Vel nam odio dolorem, voluptas sequi minus quo tempore, animi est quia earum maxime. Reiciendis quae repellat, modi non, veniam natus soluta at optio vitae in excepturi minima eveniet dolor."

class AutolayoutTableViewCell: UITableViewCell, ConfigurableCell {
    
    typealias T = Void
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    static var estimatedHeight: CGFloat? {
        return 700
    }
    
    func configure(with string: T) {
        
        titleLabel.text = LoremIpsumTitle
        subtitleLabel.text = LoremIpsumBody
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.size.width
        subtitleLabel.preferredMaxLayoutWidth = subtitleLabel.bounds.size.width
    }
}