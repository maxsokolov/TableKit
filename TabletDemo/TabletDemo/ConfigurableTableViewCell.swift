//
//  ConfigurableTableViewCell.swift
//  TabletDemo
//
//  Created by Max Sokolov on 08/11/15.
//  Copyright © 2015 Tablet. All rights reserved.
//

import UIKit

let kConfigurableTableViewCellButtonClickedAction = "button_clicked"

class ConfigurableTableViewCell: UITableViewCell, ConfigurableCell {

    typealias Item = String

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var contentLabel: UILabel!

    static func reusableIdentifier() -> String {

        return "configurable_cell"
    }

    func configureWithItem(item: Item) {

        button.setTitle("Button \(item)", forState: .Normal)
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
    
        Action(key: kConfigurableTableViewCellButtonClickedAction, sender: self).invoke()
    }
}