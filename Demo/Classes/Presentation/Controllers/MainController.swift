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
            tableDirector.register(ConfigurableTableViewCell.self)
        }
    }
    var tableDirector: TableDirector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TableKit"

        let clickAction = TableRowAction<ConfigurableTableViewCell>(.click) { [weak self] (data) in
            
            switch data.path.row {
            case 0:
                self?.performSegueWithIdentifier("autolayoutcells", sender: nil)
            case 1:
                self?.performSegueWithIdentifier("rowbuildercells", sender: nil)
            case 2:
                self?.performSegueWithIdentifier("nibcells", sender: nil)
            default:
                break
            }
        }
        
        let rows: [Row] = [

            TableRow<ConfigurableTableViewCell>(item: "Autolayout cells", actions: [clickAction]),
            TableRow<ConfigurableTableViewCell>(item: "Row builder cells", actions: [clickAction]),
            TableRow<ConfigurableTableViewCell>(item: "Nib cells", actions: [clickAction])
        ]

        // automatically creates a section, also could be used like tableDirector.append(rows: rows)
        tableDirector += rows
    }
}