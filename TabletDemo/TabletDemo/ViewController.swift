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
            .action(.configure) { data in

                data.cell?.textLabel?.text = "\(data.item)"
            }
            .action(.shouldHighlight) { data in
                
                return false
            }
            .action(kTableDirectorDidEndDisplayingCell) { data -> Void in

                print("end display: \(data.indexPath)")
            }

        let configurableRowBuilder = TableConfigurableRowBuilder<String, ConfigurableTableViewCell>(items: ["5", "6", "7", "8"], estimatedRowHeight: 300)
            .action(.click) { data -> Void in

                print("click action indexPath: \(data.indexPath), item: \(data.item)")
            }
            .action(kConfigurableTableViewCellButtonClickedAction) { data -> Void in
                
                print("custom action indexPath: \(data.indexPath), item: \(data.item)")
            }
            .action(.height) { data -> ReturnValue in

                if data.item == "5" {
                    return 70
                }
                return nil
            }
            .action(.configure) { (data) -> Void in

                data.cell!.contentLabel.text = "With iOS 8, Apple has internalized much of the work that previously had to be implemented by you prior to iOS 8. In order to allow the self-sizing cell mechanism to work, you must first set the rowHeight property on the table view to the constant UITableViewAutomaticDimension. Then, you simply need to enable row height estimation by setting the table view's estimatedRowHeight property to a nonzero value, for example"
            }

        let sectionBuilder = TableSectionBuilder(headerTitle: "Tablet", footerTitle: "Deal with table view like a boss.", rowBuilders: [rowBuilder, configurableRowBuilder])

        tableDirector.appendSection(sectionBuilder)
    }
}