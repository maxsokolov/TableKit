//
//  MainViewController.swift
//  TabletDemo
//
//  Created by Max Sokolov on 19/03/16.
//  Copyright © 2016 Tablet. All rights reserved.
//

import Foundation
import UIKit
import Tablet

class MainViewController : UITableViewController {
    
    var tableDirector: TableDirector!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableDirector = TableDirector(tableView: tableView)

        tableDirector += TableRowBuilder<Int, UITableViewCell>(items: [1, 2, 3, 4], id: "cell")
            .action(.configure) { data -> Void in

                data.cell?.accessoryType = .DisclosureIndicator
                data.cell?.textLabel?.text = "\(data.item)"
            }
            .action(.click) { data -> Void in
                
                
            }
    }
}