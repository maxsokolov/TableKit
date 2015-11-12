//
//  ViewController.swift
//  TabletDemo
//
//  Created by Max Sokolov on 08/11/15.
//  Copyright © 2015 Tablet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tableDirector: TableDirector!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableDirector = TableDirector(tableView: tableView)

        let rowBuilder = TableRowBuilder<Int, UITableViewCell>(items: [1, 2, 3, 4], id: "cell")
            .action(.configure) { data -> Void in

                data.cell?.textLabel?.text = "\(data.item)"
            }
            .action(.height) { data in
                
                return 50
            }
            .action(.shouldHighlight) { data in
                
                return false
            }
        
        let configurableRowBuilder = TableConfigurableRowBuilder<String, ConfigurableTableViewCell>(items: ["5", "6", "7", "8"])
            .action(kConfigurableTableViewCellButtonClickedAction) { data -> Void in
                
                print("custom action indexPath: \(data.indexPath), item: \(data.item)")
            }
            .action(.click) { data -> Void in
                
                data.cell!.textLabel?.text = ""
                
                print("custom action indexPath: \(data.indexPath), item: \(data.item)")
            }
        
        let sectionBuilder = TableSectionBuilder(headerTitle: "Tablet", footerTitle: "Deal with table view like a boss.", rowBuilders: [rowBuilder, configurableRowBuilder])

        tableDirector.appendSection(sectionBuilder)
    }
}