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

    weak var tableDirector: TableDirector?

    public private(set) var items = [Row]()

    public var headerTitle: String?
    public var footerTitle: String?

    public private(set) var headerView: UIView?
    public private(set) var footerView: UIView?

    public var numberOfRows: Int {
        return items.count
    }
    
    public init(rows: [Row]? = nil) {
     
        if let initialRows = rows {
            items.appendContentsOf(initialRows)
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
        items.removeAll()
    }
    
    public func append(row row: Row) {
        append(rows: [row])
    }
    
    public func append(rows rows: [Row]) {
        items.appendContentsOf(rows)
    }

    public func insert(row row: Row, atIndex index: Int) {
        items.insert(row, atIndex: index)
    }

    public func delete(index: Int) {
        items.removeAtIndex(index)
    }
}