//
//  MainController.swift
//  TabletDemo
//
//  Created by Max Sokolov on 16/04/16.
//  Copyright © 2016 Tablet. All rights reserved.
//

import UIKit
import Tablet

class MainController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableDirector = TableDirector(tableView: tableView)
        }
    }
    var tableDirector: TableDirector!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rowBuilder = TableRowBuilder<String, StoryboardImageTableViewCell>(items: ["1", "1", "1", "1"])
            .action(.click) { [unowned self] e in
                self.performSegueWithIdentifier("headerfooter", sender: nil)
            }
        
        let rows2 = TableRowBuilder<String, StoryboardImageTableViewCell>(items: ["1", "1", "1", "1"])
        

        
        let section = TableSectionBuilder(headerTitle: "", footerTitle: "", rows: [rowBuilder])
        
        //tableView.moveSection(0, toSection: 0)
        //tableView.reloadSections([], withRowAnimation: .None)
        //tableView.deleteSections([], withRowAnimation: .None)
        //tableView.insertSections([], withRowAnimation: .None)
        
        
        
        tableDirector.performBatchUpdates {
            
            rowBuilder
                .delete(indexes: [0], animated: .None)
                .insert(["2"], atIndex: 0, animated: .None)
                .update(index: 0, item: "", animated: .None)
                .move([1, 2], toIndexes: [3, 4])
        }
        
        tableDirector.append(section: section)

        tableDirector += rowBuilder
        tableDirector += rows2
    }
}