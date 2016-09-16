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

public protocol CellHeightCalculatable {

    func height(_ row: Row, path: IndexPath) -> CGFloat
    func estimatedHeight(_ row: Row, path: IndexPath) -> CGFloat
    
    func invalidate()
}

open class PrototypeHeightStrategy: CellHeightCalculatable {

    fileprivate weak var tableView: UITableView?
    fileprivate var prototypes = [String: UITableViewCell]()
    fileprivate var cachedHeights = [Int: CGFloat]()
    fileprivate var separatorHeight = 1 / UIScreen.main.scale
    
    init(tableView: UITableView?) {
        self.tableView = tableView
    }
    
    open func height(_ row: Row, path: IndexPath) -> CGFloat {

        guard let tableView = tableView else { return 0 }

        let hash = row.hashValue ^ Int(tableView.bounds.size.width).hashValue

        if let height = cachedHeights[hash] {
            return height
        }

        var prototypeCell = prototypes[row.reuseIdentifier]
        if prototypeCell == nil {

            prototypeCell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier)
            prototypes[row.reuseIdentifier] = prototypeCell
        }

        guard let cell = prototypeCell else { return 0 }
        
        row.configure(cell)
        
        cell.bounds = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: cell.bounds.height)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()

        let height = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + (tableView.separatorStyle != .none ? separatorHeight : 0)

        cachedHeights[hash] = height

        return height
    }

    open func estimatedHeight(_ row: Row, path: IndexPath) -> CGFloat {

        guard let tableView = tableView else { return 0 }

        let hash = row.hashValue ^ Int(tableView.bounds.size.width).hashValue

        if let height = cachedHeights[hash] {
            return height
        }

        if let estimatedHeight = row.estimatedHeight , estimatedHeight > 0 {
            return estimatedHeight
        }

        return UITableViewAutomaticDimension
    }

    open func invalidate() {
        cachedHeights.removeAll()
    }
}
