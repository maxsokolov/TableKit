//
//  MainController.swift
//  TabletDemo
//
//  Created by Max Sokolov on 16/04/16.
//  Copyright © 2016 Tablet. All rights reserved.
//

import UIKit
import Tablet

class LolCell: UITableViewCell, ConfigurableCell {
    
    typealias T = String
    
    func configure(str: T) {
        
    }
    
    static func estimatedHeight() -> Float {
        return 44
    }
}

class MainController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableDirector = TableDirector(tableView: tableView)
        }
    }
    var tableDirector: TableDirector!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rows = TablePrototypeRowBuilder<String, StoryboardImageTableViewCell>(items: ["1", "1", "1", "1"])
            .action(.click) { [unowned self] e in
                self.performSegueWithIdentifier("headerfooter", sender: nil)
            }
        
        let rows2 = TablePrototypeRowBuilder<String, StoryboardImageTableViewCell>(items: ["1", "1", "1", "1"])
        
        // animation task
        rows.remove(index: 0, animated: .None)

        tableDirector += rows
        tableDirector += rows2
        
        let lolBuilder = LolRowBuilder()
        
        lolBuilder.append(["1", "2", "3"], cellType: LolCell.self)
    }
}