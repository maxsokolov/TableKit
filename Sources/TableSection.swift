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

import UIKit

public class TableSection {

    public private(set) var rows = [Row]()
    
    public var headerTitle: String?
    public var footerTitle: String?
    
    public var headerView: UIView?
    public var footerView: UIView?
    
    public var headerHeight: CGFloat? = nil
    public var footerHeight: CGFloat? = nil
    
    public var numberOfRows: Int {
        return rows.count
    }
    
    public var isEmpty: Bool {
        return rows.isEmpty
    }
    
    public init(rows: [Row]? = nil) {
        
        if let initialRows = rows {
            self.rows.appendContentsOf(initialRows)
        }
    }
    
    public convenience init(headerTitle: String?, footerTitle: String?, rows: [Row]? = nil) {
        self.init(rows: rows)
        
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
    }
    
    public convenience init(headerView: UIView?, footerView: UIView?, rows: [Row]? = nil) {
        self.init(rows: rows)
        
        self.headerView = headerView
        self.footerView = footerView
    }

    // MARK: - Public -
    
    public func clear() {
        rows.removeAll()
    }
    
    public func append(row row: Row) {
        append(rows: [row])
    }
    
    public func append(rows rows: [Row]) {
        self.rows.appendContentsOf(rows)
    }
    
    public func insert(row row: Row, at index: Int) {
        rows.insert(row, atIndex: index)
    }
    
    public func insert(rows rows: [Row], at index: Int) {
        self.rows.insertContentsOf(rows, at: index)
    }

    public func replace(rowAt index: Int, with row: Row) {
        rows[index] = row
    }
    
    public func delete(index index: Int) {
        rows.removeAtIndex(index)
    }
}