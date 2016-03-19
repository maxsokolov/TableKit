//
//  TableDirectorTests.swift
//  TabletDemo
//
//  Created by Max Sokolov on 19/03/16.
//  Copyright © 2016 Tablet. All rights reserved.
//

import XCTest
import Tablet

class TestController : UITableViewController {

    var tableDirector: TableDirector!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableDirector = TableDirector(tableView: tableView)
    }
}

class TabletTests: XCTestCase {

    var testController: TestController!

    override func setUp() {
        super.setUp()

        testController = TestController()
    }
    
    override func tearDown() {
   
        testController = nil
        super.tearDown()
    }

    func testTableDirectorHasTableView() {

        XCTAssertNotNil(testController.tableView, "TestController should have table view")
        XCTAssertNotNil(testController.tableDirector, "TestController should have table director")
        XCTAssertNotNil(testController.tableDirector.tableView, "TableDirector should have table view")
    }
    
    func testSimpleRowBuilder() {

        let source = ["1", "2", "3"]

        let row = TableRowBuilder<String, UITableViewCell>(items: source)
            .action(.configure) { data -> Void in

                XCTAssertNotNil(data.cell, "Action should have cell")
                data.cell?.textLabel?.text = "\(data.item)"
            }
        
        testController.view.hidden = false
        testController.tableDirector += row
        testController.tableView.reloadData()

        XCTAssertTrue(testController.tableView.dataSource?.numberOfSectionsInTableView?(testController.tableView) == 1, "Table view should have a section")
        XCTAssertTrue(testController.tableView.dataSource?.tableView(testController.tableView, numberOfRowsInSection: 0) == source.count, "Table view should have certain number of rows in a section")
        
        for (index, element) in source.enumerate() {
            
            let cell = testController.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            
            XCTAssertNotNil(cell)
            XCTAssertTrue(cell?.textLabel?.text == element)
        }
    }
}