//
//  StoryboardTableViewCell.swift
//  TabletDemo
//
//  Created by Max Sokolov on 16/04/16.
//  Copyright © 2016 Tablet. All rights reserved.
//

import UIKit
import Tablet

class StoryboardTableViewCell: UITableViewCell, ConfigurableCell {

    typealias T = String

    func configure(value: T) {
        textLabel?.text = value
    }

    static func estimatedHeight() -> Float {
        return 44
    }
}