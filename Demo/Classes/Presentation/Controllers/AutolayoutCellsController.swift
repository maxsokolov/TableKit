//
//  AutolayoutCellsController.swift
//  TableKitDemo
//
//  Created by Max Sokolov on 18/06/16.
//  Copyright © 2016 Tablet. All rights reserved.
//

import UIKit
import TableKit

class AutolayoutCellsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableDirector = TableDirector(tableView: tableView)
            tableDirector.register(ConfigurableTableViewCell.self)
        }
    }
    var tableDirector: TableDirector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Autolayout cells"
        
        let section = TableSection()
        
        var rows = 0
        while rows <= 10 {
            rows += 1
            
            let row = TableRow<AutolayoutTableViewCell>(item: ())
            section += row
        }
        
        tableDirector += section
    }
}