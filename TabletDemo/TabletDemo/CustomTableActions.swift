//
//  CustomTableActions.swift
//  TabletDemo
//
//  Created by Max Sokolov on 14/11/15.
//  Copyright © 2015 Tablet. All rights reserved.
//

import UIKit
import Foundation

let kTableDirectorDidEndDisplayingCell = "enddisplaycell"

extension TableDirector {
    
    public func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        performAction(.custom(kTableDirectorDidEndDisplayingCell), cell: cell, indexPath: indexPath)
    }
}