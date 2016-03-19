//
//    Copyright (c) 2015 Max Sokolov https://twitter.com/max_sokolov
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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

                XCTAssertNotNil(data.cell, "Action should have a cell")
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