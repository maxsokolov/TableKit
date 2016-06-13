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
        
        
        let a = TableRowAction<String, StoryboardImageTableViewCell>(.click) {
            (data) in
            
            print("3", data.item)
        }
        
        
        let b = TableRowBuilder<String, StoryboardImageTableViewCell>(items: ["1", "2", "3"], actions: [a])
        
        
        let row1 = TableRow<String, StoryboardImageTableViewCell>(item: "1")
        let row2 = TableRow<String, StoryboardImageTableViewCell>(item: "2")
        let row3 = TableRow<String, StoryboardImageTableViewCell>(item: "3", actions: [a])
       
        
        
        row1
            .addAction(TableRowAction(.shouldHighlight) { (data) -> Bool in
            
                print("1")
                
                return false
            })
            .addAction(TableRowAction(.click) { (data) in
                
                print("2")
                
                
            })
        
    
        let section = TableSection()
        section.append(builder: b)

        //let section = TableSection(headerTitle: "", footerTitle: "", rows: [row1, row2, row3])
        
        tableDirector += [section]
        
        //tableDirector.append(section: section)
        
        
        
        
        
        
        /*rowBuilder
            .addAction(TableRowAction(type: .Click) { (data) in
            
                
            })
        
        rowBuilder
            .delete(indexes: [0], animated: .None)
            .insert(["2"], atIndex: 0, animated: .None)
            .update(index: 0, item: "", animated: .None)
            .move([1, 2], toIndexes: [3, 4])
        
        
        
        //tableView.moveRowAtIndexPath(<#T##indexPath: NSIndexPath##NSIndexPath#>, toIndexPath: <#T##NSIndexPath#>)
        //tableView.deleteRowsAtIndexPaths(<#T##indexPaths: [NSIndexPath]##[NSIndexPath]#>, withRowAnimation: <#T##UITableViewRowAnimation#>)
        //tableView.insertRowsAtIndexPaths(<#T##indexPaths: [NSIndexPath]##[NSIndexPath]#>, withRowAnimation: <#T##UITableViewRowAnimation#>)
        //tableView.reloadRowsAtIndexPaths(<#T##indexPaths: [NSIndexPath]##[NSIndexPath]#>, withRowAnimation: <#T##UITableViewRowAnimation#>)
        
        //tableView.moveSection(0, toSection: 0)
        //tableView.reloadSections([], withRowAnimation: .None)
        //tableView.deleteSections([], withRowAnimation: .None)
        //tableView.insertSections([], withRowAnimation: .None)
        
        //tableDirector.performBatchUpdates {
        //}*/
        
        //tableDirector.append(section: section)
    }
}