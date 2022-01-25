//
//  TableSectionUpdates.swift
//  TableKit
//
//  Created by Anton Myshkovsky on 25.01.22.
//  Copyright © 2022 Max Sokolov. All rights reserved.
//

import Foundation
import UIKit

internal struct TableSectionUpdates {
    var insertRowPaths: [IndexPath]?
    var deleteRowPaths: [IndexPath]?
    var reloadRowPaths: [IndexPath]?
    
    func apply(on tableView: UITableView?) {
        guard let tableView = tableView else {
            return
        }
        
        tableView.beginUpdates()
        
        if let deleteRowPaths = deleteRowPaths {
            tableView.deleteRows(at: deleteRowPaths, with: .automatic)
        }
        if let insertRowPaths = insertRowPaths {
            tableView.insertRows(at: insertRowPaths, with: .automatic)
        }
        if let reloadRowPaths = reloadRowPaths {
            tableView.reloadRows(at: reloadRowPaths, with: .automatic)
        }

        tableView.endUpdates()
    }
}
