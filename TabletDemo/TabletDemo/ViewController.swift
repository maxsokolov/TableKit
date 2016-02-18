//
//  ViewController.swift
//  TabletDemo
//
//  Created by Max Sokolov on 08/11/15.
//  Copyright © 2015 Tablet. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tableDirector: TableDirector!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableDirector = TableDirector(tableView: tableView)
        tableDirector.scrollDelegate = self

        let rowBuilder = TableRowBuilder<Int, UITableViewCell>(items: [1, 2, 3, 4], id: "cell", estimatedRowHeight: 44)
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

                data.cell!.contentLabel.text = "Tablet is a super lightweight yet powerful generic library that handles a complexity of UITableView's datasource and delegate methods in a Swift environment. Tablet's goal is to provide an easiest way to create complex table views. With Tablet you don't have to write a messy code of switch or if statements when you deal with bunch of different cells in different sections."
            }

        let myRowBuilder = TableRowBuilder<Int, MyTableViewCell>(item: 0, id: "cellll", estimatedRowHeight: 44)

        let sectionBuilder = TableSectionBuilder(headerTitle: "Tablet", footerTitle: "Deal with table view like a boss.", rowBuilders: [rowBuilder, configurableRowBuilder, myRowBuilder])

        tableDirector += sectionBuilder

        sectionBuilder.appendRowBuilder(TableRowBuilder<Int, MyNibTableViewCell>(item: 0, estimatedRowHeight: 44))
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("begin dragging")
    }
}