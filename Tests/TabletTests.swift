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
        
        testController.view.hidden = false

        XCTAssertNotNil(testController.tableView)
        XCTAssertNotNil(testController.tableDirector)
        XCTAssertNotNil(testController.tableDirector.tableView)
    }
}