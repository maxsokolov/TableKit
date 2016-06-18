//
//  RowBuilderCellsController.swift
//  TableKitDemo
//
//  Created by Max Sokolov on 18/06/16.
//  Copyright © 2016 Tablet. All rights reserved.
//

import UIKit
import TableKit

class RowBuilderCellsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableDirector = TableDirector(tableView: tableView)
            tableDirector.register(ConfigurableTableViewCell.self)
        }
    }
    var tableDirector: TableDirector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Row builder cells"
        
        let numbers = ["1", "2", "3", "4", "5"]
        
        let clickAction = TableRowAction<String, ConfigurableTableViewCell>(.click) { [weak self] (data) in
            
            let alert = UIAlertController(title: nil, message: data.item, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))

            self?.presentViewController(alert, animated: true, completion: nil)
        }
        
        let rowBuilder = TableRowBuilder<String, ConfigurableTableViewCell>(items: numbers, actions: [clickAction])
        
        let section = TableSection(headerTitle: "Header title", footerTitle: "Footer title")
        
        section.append(builder: rowBuilder)
        
        tableDirector.append(section: section)
    }
}