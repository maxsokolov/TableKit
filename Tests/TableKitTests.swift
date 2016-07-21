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
        tableDirector.register(TestTableViewCell.self)
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
        TableCellAction(key: TestTableViewCellOptions.CellAction, sender: self, userInfo: nil).invoke()
    }
}

class TabletTests: XCTestCase {

    var testController: TestController!

    override func setUp() {
        super.setUp()

        testController = TestController()
        testController.view.hidden = false
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
    
    func testRowInSection() {
        
        let data = TestData(title: "title")

        let row = TableRow<TestTableViewCell>(item: data)
        
        testController.tableDirector += row
        testController.tableView.reloadData()
        
        XCTAssertTrue(testController.tableView.dataSource?.numberOfSectionsInTableView?(testController.tableView) == 1, "Table view should have a section")
        XCTAssertTrue(testController.tableView.dataSource?.tableView(testController.tableView, numberOfRowsInSection: 0) == 1, "Table view should have certain number of rows in a section")
        
        let cell = testController.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? TestTableViewCell
        XCTAssertNotNil(cell)
        XCTAssertTrue(cell?.textLabel?.text == data.title)
    }
    
    func testManyRowsInSection() {
        
        let data = [TestData(title: "1"), TestData(title: "2"), TestData(title: "3")]
        
        let rows: [Row] = data.map({ TableRow<TestTableViewCell>(item: $0) })
        
        testController.tableDirector += rows
        testController.tableView.reloadData()
        
        XCTAssertTrue(testController.tableView.dataSource?.numberOfSectionsInTableView?(testController.tableView) == 1, "Table view should have a section")
        XCTAssertTrue(testController.tableView.dataSource?.tableView(testController.tableView, numberOfRowsInSection: 0) == data.count, "Table view should have certain number of rows in a section")
        
        for (index, element) in data.enumerate() {
            
            let cell = testController.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? TestTableViewCell
            XCTAssertNotNil(cell)
            XCTAssertTrue(cell?.textLabel?.text == element.title)
        }
    }
    
    func testTableSectionCreatesSectionWithHeaderAndFooterTitles() {
        
        let row = TableRow<TestTableViewCell>(item: TestData(title: "title"))
        
        let sectionHeaderTitle = "Header Title"
        let sectionFooterTitle = "Footer Title"
        
        let section = TableSection(headerTitle: sectionHeaderTitle, footerTitle: sectionFooterTitle, rows: [row])
        
        testController.tableDirector += section
        testController.tableView.reloadData()
        
        XCTAssertTrue(testController.tableView.dataSource?.numberOfSectionsInTableView?(testController.tableView) == 1, "Table view should have a section")
        XCTAssertTrue(testController.tableView.dataSource?.tableView(testController.tableView, numberOfRowsInSection: 0) == 1, "Table view should have certain number of rows in a section")
        
        XCTAssertTrue(testController.tableView.dataSource?.tableView?(testController.tableView, titleForHeaderInSection: 0) == sectionHeaderTitle)
        XCTAssertTrue(testController.tableView.dataSource?.tableView?(testController.tableView, titleForFooterInSection: 0) == sectionFooterTitle)
    }
    
    func testTableSectionCreatesSectionWithHeaderAndFooterViews() {
        
        let row = TableRow<TestTableViewCell>(item: TestData(title: "title"))
        
        let sectionHeaderView = UIView()
        let sectionFooterView = UIView()
        
        let section = TableSection(headerView: sectionHeaderView, footerView: sectionFooterView, rows: nil)
        section += row
        
        testController.tableDirector += section
        testController.tableView.reloadData()
        
        XCTAssertTrue(testController.tableView.dataSource?.numberOfSectionsInTableView?(testController.tableView) == 1, "Table view should have a section")
        XCTAssertTrue(testController.tableView.dataSource?.tableView(testController.tableView, numberOfRowsInSection: 0) == 1, "Table view should have certain number of rows in a section")
        
        XCTAssertTrue(testController.tableView.delegate?.tableView?(testController.tableView, viewForHeaderInSection: 0) == sectionHeaderView)
        XCTAssertTrue(testController.tableView.delegate?.tableView?(testController.tableView, viewForFooterInSection: 0) == sectionFooterView)
    }

    func testRowBuilderCustomActionInvokedAndSentUserInfo() {

        let expectation = expectationWithDescription("cell action")

        let row = TableRow<TestTableViewCell>(item: TestData(title: "title"))
            .action(TableRowAction(.custom(TestTableViewCellOptions.CellAction)) { (data) in
                
                XCTAssertNotNil(data.cell, "Action data should have a cell")
                
                expectation.fulfill()
            })

        testController.view.hidden = false
        testController.tableDirector += row
        testController.tableView.reloadData()
        
        let cell = testController.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? TestTableViewCell
        
        XCTAssertNotNil(cell, "Cell should exists and should be TestTableViewCell")
        
        cell?.raiseAction()

        waitForExpectationsWithTimeout(1.0, handler: nil)
    }
}