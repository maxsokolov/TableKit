//
//  MainController.swift
//  TabletDemo
//
//  Created by Max Sokolov on 16/04/16.
//  Copyright © 2016 Tablet. All rights reserved.
//

import UIKit
import TableKit

class MainController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableDirector = TableDirector(tableView: tableView)
            tableDirector.shouldUsePrototypeCellHeightCalculation = true
        }
    }
    var tableDirector: TableDirector!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let a = TableRowAction<String, StoryboardImageTableViewCell>(.click) {
            (data) in
            
            print("3", data.item)
        }
        
        
        let b = TableRowBuilder<String, StoryboardImageTableViewCell>(items: ["1", "2", "3"], actions: [a])
        
        
        let row1 = TableRow<String, StoryboardImageTableViewCell>(item: "1")
        let row2 = TableRow<String, StoryboardImageTableViewCell>(item: "2")
        let row3 = TableRow<String, StoryboardImageTableViewCell>(item: "3", actions: [a])

        row1
            .action(TableRowAction(.shouldHighlight) { (data) -> Bool in

                print("1")
                
                return false
            })
            .action(TableRowAction(.click) { (data) in
                
                print("2")
            })
    
        let section = TableSection()
        section.append(builder: b)

        tableDirector += [section]
    }
}