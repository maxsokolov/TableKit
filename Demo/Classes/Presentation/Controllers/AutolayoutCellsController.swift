//
//  AutolayoutCellsController.swift
//  TableKitDemo
//
//  Created by Max Sokolov on 18/06/16.
//  Copyright © 2016 Tablet. All rights reserved.
//

import UIKit
import TableKit

class AutolayoutCellsController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableDirector = TableDirectorV2(tableView: tableView, scrollDelegate: self)
        }
    }
    var tableDirector: TableDirectorV2!
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        randomString += "// END"
        
        return randomString
    }
    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Autolayout cells"
        
        let section = TableSection()
        
        var rows = 0
        while rows <= 20 {
            rows += 1
            
            let row = TableRow<AutolayoutTableViewCell>(item: randomString(length: randomInt(min: 20, max: 100)))
            section += row
        }
        
        tableDirector.append(section: section)
        //tableDirector += section
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("begin dragging")
    }
}
