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
import TableKit

class TestController: UITableViewController {

    var tableDirector: TableDirector!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableDirector = TableDirector(tableView: tableView)
        tableDirector.register([TestTableViewCell.self])
    }
}

struct TestData {

    let title: String
}

struct TestTableViewCellOptions {

    static let ReusableIdentifier: String = "ReusableIdentifier"
    static let CellAction: String = "CellAction"
    static let CellActionUserInfoKey: String = "CellActionUserInfoKey"
    static let CellActionUserInfoValue: String = "CellActionUserInfoValue"
    static let EstimatedHeight: Float = 255
}

class TestTableViewCell: UITableViewCell, ConfigurableCell {

    typealias T = TestData
    
    static func reusableIdentifier() -> String {
        return TestTableViewCellOptions.ReusableIdentifier
    }

    static func estimatedHeight() -> Float {
        return TestTableViewCellOptions.EstimatedHeight
    }

    func configure(item: T, isPrototype: Bool) {
        textLabel?.text = item.title
    }

    func raiseAction() {
        //Action(key: TestTableViewCellOptions.CellAction, sender: self, userInfo: [TestTableViewCellOptions.CellActionUserInfoKey: TestTableViewCellOptions.CellActionUserInfoValue]).invoke()
    }
}

class TabletTests: XCTestCase {

    var testController: TestController!

    override func setUp() {
        super.setUp()

        testController = TestController()
        let _ = testController.view
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
    
    func testRow() {
        
        let data = TestData(title: "title")

        let row = TableRow<TestData, TestTableViewCell>(item: data)
        
        testController.tableDirector += row
        
        XCTAssertTrue(testController.tableView.dataSource?.numberOfSectionsInTableView?(testController.tableView) == 1, "Table view should have a section")
        XCTAssertTrue(testController.tableView.dataSource?.tableView(testController.tableView, numberOfRowsInSection: 0) == 1, "Table view should have certain number of rows in a section")
        
        let cell = testController.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? TestTableViewCell
        XCTAssertNotNil(cell)
    }
    
    /*func testSimpleRowBuilderCreatesRowsAndSection() {

        let source = ["1", "2", "3"]

        let rows = TableBaseRowBuilder<String, UITableViewCell>(items: source)
            .action(.configure) { data -> Void in

                XCTAssertNotNil(data.cell, "Action should have a cell")
                data.cell?.textLabel?.text = "\(data.item)"
            }
        
        testController.view.hidden = false
        testController.tableDirector += rows
        testController.tableView.reloadData()

        XCTAssertTrue(testController.tableView.dataSource?.numberOfSectionsInTableView?(testController.tableView) == 1, "Table view should have a section")
        XCTAssertTrue(testController.tableView.dataSource?.tableView(testController.tableView, numberOfRowsInSection: 0) == source.count, "Table view should have certain number of rows in a section")
        
        for (index, element) in source.enumerate() {
            
            let cell = testController.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            
            XCTAssertNotNil(cell)
            XCTAssertTrue(cell?.textLabel?.text == element)
        }
    }

    func testConfigurableRowBuilderCreatesRowsAndSection() {

        let testData = TestData(title: "title")
        
        testController.view.hidden = false
        testController.tableDirector += TableRowBuilder<TestData, TestTableViewCell>(item: testData)
        testController.tableView.reloadData()

        let cell = testController.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? TestTableViewCell
        
        XCTAssertNotNil(cell, "Cell should exists and should be TestTableViewCell")
        XCTAssertTrue(cell?.textLabel?.text == testData.title, "Cell's textLabel.text should equal to testData's title")
    }

    func testSectionBuilderCreatesSectionWithHeaderAndFooterTitles() {

        let row = TableRowBuilder<TestData, TestTableViewCell>(items: [TestData(title: "title")])

        let sectionHeaderTitle = "Header Title"
        let sectionFooterTitle = "Footer Title"

        let section = TableSectionBuilder(headerTitle: sectionHeaderTitle, footerTitle: sectionFooterTitle, rows: [row])

        testController.view.hidden = false
        testController.tableDirector += section
        testController.tableView.reloadData()

        XCTAssertTrue(testController.tableView.dataSource?.numberOfSectionsInTableView?(testController.tableView) == 1, "Table view should have a section")
        XCTAssertTrue(testController.tableView.dataSource?.tableView(testController.tableView, numberOfRowsInSection: 0) == 1, "Table view should have certain number of rows in a section")
        
        XCTAssertTrue(testController.tableView.dataSource?.tableView?(testController.tableView, titleForHeaderInSection: 0) == sectionHeaderTitle)
        XCTAssertTrue(testController.tableView.dataSource?.tableView?(testController.tableView, titleForFooterInSection: 0) == sectionFooterTitle)
    }
    
    func testSectionBuilderCreatesSectionWithHeaderAndFooterViews() {

        let row = TableRowBuilder<TestData, TestTableViewCell>(items: [TestData(title: "title")])
        
        let sectionHeaderView = UIView()
        let sectionFooterView = UIView()

        let section = TableSectionBuilder(headerView: sectionHeaderView, footerView: sectionFooterView, rows: nil)
        section += row
        
        testController.view.hidden = false
        testController.tableDirector += section
        testController.tableView.reloadData()
        
        XCTAssertTrue(testController.tableView.dataSource?.numberOfSectionsInTableView?(testController.tableView) == 1, "Table view should have a section")
        XCTAssertTrue(testController.tableView.dataSource?.tableView(testController.tableView, numberOfRowsInSection: 0) == 1, "Table view should have certain number of rows in a section")
        
        XCTAssertTrue(testController.tableView.delegate?.tableView?(testController.tableView, viewForHeaderInSection: 0) == sectionHeaderView)
        XCTAssertTrue(testController.tableView.delegate?.tableView?(testController.tableView, viewForFooterInSection: 0) == sectionFooterView)
    }
    
    func testRowBuilderCustomActionInvokedAndSentUserInfo() {

        let expectation = expectationWithDescription("cell action")

        let row = TableRowBuilder<TestData, TestTableViewCell>(items: [TestData(title: "title")])
            .action(TestTableViewCellOptions.CellAction) { data -> Void in

                XCTAssertNotNil(data.cell, "Action data should have a cell")
                XCTAssertNotNil(data.userInfo, "Action data should have a user info dictionary")
                XCTAssertTrue(data.userInfo?[TestTableViewCellOptions.CellActionUserInfoKey] as? String == TestTableViewCellOptions.CellActionUserInfoValue, "UserInfo should have correct value for key")

                expectation.fulfill()
            }

        testController.view.hidden = false
        testController.tableDirector += row
        testController.tableView.reloadData()
        
        let cell = testController.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? TestTableViewCell
        
        XCTAssertNotNil(cell, "Cell should exists and should be TestTableViewCell")
        
        cell?.raiseAction()

        waitForExpectationsWithTimeout(1.0, handler: nil)
    }*/
}