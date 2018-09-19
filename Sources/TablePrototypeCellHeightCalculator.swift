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

open class TablePrototypeCellHeightCalculator: RowHeightCalculator {

    private(set) weak var tableView: UITableView?
    private var prototypes = [String: UITableViewCell]()
    private var cachedHeights = [Int: CGFloat]()
    private var separatorHeight = 1 / UIScreen.main.scale
    
    public init(tableView: UITableView?) {
        self.tableView = tableView
    }
    
    open func height(forRow row: Row, at indexPath: IndexPath) -> CGFloat {

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
        
        cell.prepareForReuse()
        row.configure(cell)
        
        cell.bounds = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: cell.bounds.height)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()

        let height = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height + (tableView.separatorStyle != .none ? separatorHeight : 0)

        cachedHeights[hash] = height

        return height
    }

    open func estimatedHeight(forRow row: Row, at indexPath: IndexPath) -> CGFloat {

        guard let tableView = tableView else { return 0 }

        let hash = row.hashValue ^ Int(tableView.bounds.size.width).hashValue

        if let height = cachedHeights[hash] {
            return height
        }

        if let estimatedHeight = row.estimatedHeight , estimatedHeight > 0 {
            return estimatedHeight
        }

        return UITableView.automaticDimension
    }

    open func invalidate() {
        cachedHeights.removeAll()
    }
}
