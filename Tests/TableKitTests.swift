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
    static let EstimatedHeight: CGFloat = 255
}

class TestTableViewCell: UITableViewCell, ConfigurableCell {

    typealias T = TestData
    
    static var estimatedHeight: CGFloat? {
        return TestTableViewCellOptions.EstimatedHeight
    }
    
    static var reuseIdentifier: String {
        return TestTableViewCellOptions.ReusableIdentifier
    }

    func configure(with item: T) {
        textLabel?.text = item.title
    }

    func raiseAction() {
        TableCellAction(key: TestTableViewCellOptions.CellAction, sender: self, userInfo: nil).invoke()
    }
}

class TableKitTests: XCTestCase {

    var testController: TestController!

    override func setUp() {
        super.setUp()

        testController = TestController()
        testController.tableView.frame = UIScreen.main.bounds
        testController.tableView.isHidden = false
        testController.tableView.setNeedsLayout()
        testController.tableView.layoutIfNeeded()
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
        
        XCTAssertTrue(testController.tableView.dataSource?.numberOfSections?(in: testController.tableView) == 1, "Table view should have a section")
        XCTAssertTrue(testController.tableView.dataSource?.tableView(testController.tableView, numberOfRowsInSection: 0) == 1, "Table view should have certain number of rows in a section")
        
        let cell = testController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TestTableViewCell
        XCTAssertNotNil(cell)
        XCTAssertTrue(cell?.textLabel?.text == data.title)
    }
    
    func testManyRowsInSection() {
        
        let data = [TestData(title: "1"), TestData(title: "2"), TestData(title: "3")]
        
        let rows: [Row] = data.map({ TableRow<TestTableViewCell>(item: $0) })
        
        testController.tableDirector += rows
        testController.tableView.reloadData()
        
        XCTAssertTrue(testController.tableView.dataSource?.numberOfSections?(in: testController.tableView) == 1, "Table view should have a section")
        XCTAssertTrue(testController.tableView.dataSource?.tableView(testController.tableView, numberOfRowsInSection: 0) == data.count, "Table view should have certain number of rows in a section")
        
        for (index, element) in data.enumerated() {
            
            let cell = testController.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TestTableViewCell
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
        
        XCTAssertTrue(testController.tableView.dataSource?.numberOfSections?(in: testController.tableView) == 1, "Table view should have a section")
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
        
        XCTAssertTrue(testController.tableView.dataSource?.numberOfSections?(in: testController.tableView) == 1, "Table view should have a section")
        XCTAssertTrue(testController.tableView.dataSource?.tableView(testController.tableView, numberOfRowsInSection: 0) == 1, "Table view should have certain number of rows in a section")
        
        XCTAssertTrue(testController.tableView.delegate?.tableView?(testController.tableView, viewForHeaderInSection: 0) == sectionHeaderView)
        XCTAssertTrue(testController.tableView.delegate?.tableView?(testController.tableView, viewForFooterInSection: 0) == sectionFooterView)
    }

    func testRowBuilderCustomActionInvokedAndSentUserInfo() {

        let expectation = self.expectation(description: "cell action")

        let row = TableRow<TestTableViewCell>(item: TestData(title: "title"))
            .on(TableRowAction(.custom(TestTableViewCellOptions.CellAction)) { (data) in
                
                XCTAssertNotNil(data.cell, "Action data should have a cell")
                
                expectation.fulfill()
            })

        testController.view.isHidden = false
        testController.tableDirector += row
        testController.tableView.reloadData()
        
        let cell = testController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TestTableViewCell
        
        XCTAssertNotNil(cell, "Cell should exists and should be TestTableViewCell")
        
        cell?.raiseAction()

        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testReplaceSectionOnExistingIndex() {
        
        let row1 = TableRow<TestTableViewCell>(item: TestData(title: "title1"))
        let row2 = TableRow<TestTableViewCell>(item: TestData(title: "title2"))
    
        let section1 = TableSection(headerView: nil, footerView: nil, rows: nil)
        section1 += row1
        
        let section2 = TableSection(headerView: nil, footerView: nil, rows: nil)
        section2 += row2
        
        testController.tableDirector += section1
        testController.tableView.reloadData()
        
        let cell = testController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TestTableViewCell
        XCTAssertTrue(cell?.textLabel?.text == "title1")
        
        testController.tableDirector.replaceSection(at: 0, with: section2)
        testController.tableView.reloadData()
        
       let cell1 = testController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TestTableViewCell
        XCTAssertTrue(cell1?.textLabel?.text == "title2")
    }
    
    func testReplaceSectionOnWrongIndex() {
        
        let row1 = TableRow<TestTableViewCell>(item: TestData(title: "title1"))
        let row2 = TableRow<TestTableViewCell>(item: TestData(title: "title2"))
        
        let section1 = TableSection(headerView: nil, footerView: nil, rows: nil)
        section1 += row1
        
        let section2 = TableSection(headerView: nil, footerView: nil, rows: nil)
        section2 += row2
        
        testController.tableDirector += section1
        testController.tableView.reloadData()
        
        let cell = testController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TestTableViewCell
        XCTAssertTrue(cell?.textLabel?.text == "title1")
        
        testController.tableDirector.replaceSection(at: 33, with: section2)
        testController.tableView.reloadData()
        
        let cell1 = testController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TestTableViewCell
        XCTAssertTrue(cell1?.textLabel?.text == "title1")
    }
    
}
