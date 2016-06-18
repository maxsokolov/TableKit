//
//  StoryboardTableViewCell.swift
//  TabletDemo
//
//  Created by Max Sokolov on 16/04/16.
//  Copyright © 2016 Tablet. All rights reserved.
//

import UIKit
import TableKit

class StoryboardTableViewCell: UITableViewCell, ConfigurableCell {

    typealias T = String

    func configure(value: T, isPrototype: Bool) {
        textLabel?.text = value
    }
}