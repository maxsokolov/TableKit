//
//  NibCellsController.swift
//  TableKitDemo
//
//  Created by Max Sokolov on 18/06/16.
//  Copyright © 2016 Tablet. All rights reserved.
//

import UIKit
import TableKit

class NibCellsController: UITableViewController {
    
    var tableDirector: TableDirector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nib cells"
        
        tableDirector = TableDirector(tableView: tableView)
        //tableDirector.shouldUsePrototypeCellHeightCalculation = true
        
        let numbers = [1000, 2000, 3000, 4000, 5000]
        
        let shouldHighlightAction = TableRowAction<Int, NibTableViewCell>(.shouldHighlight) { (_) -> Bool in
            return false
        }

        let rows: [Row] = numbers.map { TableRow<Int, NibTableViewCell>(item: $0, actions: [shouldHighlightAction]) }
        
        tableDirector.append(rows: rows)
    }
}