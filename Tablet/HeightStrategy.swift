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

public protocol HeightStrategy {
    
    func height<Item: Hashable, Cell: ConfigurableCell where Cell.T == Item, Cell: UITableViewCell>(item: Item, cell: Cell.Type) -> CGFloat
    
    func estimatedHeight() -> CGFloat
}

public class AutolayoutHeightStrategy: HeightStrategy {
    
    public func height<Item, Cell: ConfigurableCell where Cell.T == Item, Cell: UITableViewCell>(item: Item, cell: Cell.Type) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func estimatedHeight() -> CGFloat {
        return 0
    }
}

public class PrototypeHeightStrategy: HeightStrategy {
    
    private weak var tableView: UITableView?
    
    public init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    public func height<Item: Hashable, Cell: ConfigurableCell where Cell.T == Item, Cell: UITableViewCell>(item: Item, cell: Cell.Type) -> CGFloat {
        
        guard let cell = tableView?.dequeueReusableCellWithIdentifier(Cell.reusableIdentifier()) as? Cell else { return 0 }
        
        cell.bounds = CGRectMake(0, 0, tableView?.bounds.size.width ?? 0, cell.bounds.height)
        
        cell.configure(item)
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        return cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 1
    }
    
    public func estimatedHeight() -> CGFloat {
        return UITableViewAutomaticDimension
    }
}