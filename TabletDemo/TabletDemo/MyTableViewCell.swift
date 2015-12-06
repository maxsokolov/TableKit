//
//  MyTableViewCell.swift
//  TabletDemo
//
//  Created by Max Sokolov on 07/12/15.
//  Copyright © 2015 Tablet. All rights reserved.
//

import Foundation
import UIKit

class MyTableViewCell : UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.redColor()
    }
}