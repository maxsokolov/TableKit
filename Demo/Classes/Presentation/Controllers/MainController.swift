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
        }
    }
    var tableDirector: TableDirector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TableKit"

        let clickAction = TableRowAction<String, ConfigurableTableViewCell>(.click) { [weak self] (data) in
            
            switch (data.indexPath as NSIndexPath).row {
            case 0:
                self?.performSegue(withIdentifier: "autolayoutcells", sender: nil)
            case 1:
                self?.performSegue(withIdentifier: "nibcells", sender: nil)
            default:
                break
            }
        }

        let rows = [

            TableRow<String, ConfigurableTableViewCell>(item: "Autolayout cells", actions: [clickAction]),
            TableRow<String, ConfigurableTableViewCell>(item: "Nib cells", actions: [clickAction])
        ]

        // automatically creates a section, also could be used like tableDirector.append(rows: rows)
        tableDirector += rows
    }
}
