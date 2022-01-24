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

internal struct TableSectionUpdates {
    var insertRowPaths: [IndexPath]?
    var deleteRowPaths: [IndexPath]?
    var reloadRowPaths: [IndexPath]?
    
    func apply(on tableView: UITableView?) {
        guard let tableView = tableView else {
            return
        }

        tableView.performBatchUpdates({
            if let deleteRowPaths = deleteRowPaths {
                tableView.deleteRows(at: deleteRowPaths, with: .automatic)
            }
            if let insertRowPaths = insertRowPaths {
                tableView.insertRows(at: insertRowPaths, with: .automatic)
            }
        }, completion: {
            _ in
            if let reloadRowPaths = reloadRowPaths {
                tableView.reloadRows(at: reloadRowPaths, with: .automatic)
            }
        })
    }
}

open class TableSection {

    open private(set) var rows = [Row]()
    
    open var headerTitle: String?
    open var footerTitle: String?
    open var indexTitle: String?
    
    open var headerView: UIView?
    open var footerView: UIView?
    
    open var headerHeight: CGFloat? = nil
    open var footerHeight: CGFloat? = nil
    
    internal var modifications: TableSectionUpdates? = nil
    
    open var numberOfRows: Int {
        return rows.count
    }
    
    open var isEmpty: Bool {
        return rows.isEmpty
    }
    
    public init(rows: [Row]? = nil) {
        
        if let initialRows = rows {
            self.rows.append(contentsOf: initialRows)
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
    
    open func clear() {
        rows.removeAll()
    }
    
    open func append(row: Row) {
        append(rows: [row])
    }
    
    open func append(rows: [Row]) {
        self.rows.append(contentsOf: rows)
    }
    
    open func insert(row: Row, at index: Int) {
        rows.insert(row, at: index)
    }
    
    open func insert(rows: [Row], at index: Int) {
        self.rows.insert(contentsOf: rows, at: index)
    }

    open func replace(rowAt index: Int, with row: Row) {
        rows[index] = row
    }
    
    open func swap(from: Int, to: Int) {
        rows.swapAt(from, to)
    }
    
    open func delete(rowAt index: Int) {
        rows.remove(at: index)
    }
    
    open func remove(rowAt index: Int) {
        rows.remove(at: index)
    }
    
    // MARK: - Section changes -
    
    open func performUpdates(reloadRows: Bool = false, _ updates: @autoclosure () -> Void) {
        modifications = nil
        let oldRowsCount = rows.count
        updates()
        let newRowsCount = rows.count
        
        modifications = TableSectionUpdates()
        let reloadRowsPaths = (0..<min(oldRowsCount, newRowsCount)).map {
            IndexPath(row: $0, section: 0)
        }
        let insertOrDeletePaths = (min(oldRowsCount, newRowsCount)..<max(oldRowsCount, newRowsCount)).map {
            IndexPath(row: $0, section: 0)
        }
        if oldRowsCount > newRowsCount {
            modifications?.deleteRowPaths = insertOrDeletePaths
        } else {
            modifications?.insertRowPaths = insertOrDeletePaths
        }

        modifications?.reloadRowPaths = reloadRows ? reloadRowsPaths : nil
    }

    // MARK: - deprecated methods -
    
    @available(*, deprecated, message: "Use 'delete(rowAt:)' method instead")
    open func delete(index: Int) {
        rows.remove(at: index)
    }
}
