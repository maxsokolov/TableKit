//
//  HeaderFooterController.swift
//  TabletDemo
//
//  Created by Max Sokolov on 16/04/16.
//  Copyright © 2016 Tablet. All rights reserved.
//

import UIKit
import Tablet

class HeaderFooterController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableDirector = TableDirector(tableView: tableView)
        }
    }
    var tableDirector: TableDirector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let rows = TableRowBuilder<String, StoryboardTableViewCell>(items: ["3", "4", "5"])
        
        //let headerView = UIView(frame: CGRectMake(0, 0, 100, 100))
        //headerView.backgroundColor = UIColor.lightGrayColor()
        
        //let section = TableSectionBuilder(headerView: headerView, footerView: nil, rows: [rows])
        
        //tableDirector += section
    }
}