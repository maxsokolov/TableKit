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

public protocol HeightCalculatingStrategy {

    var tableView: UITableView? { get set }

    func height(indexPath: NSIndexPath, reusableIdentifier: String, configure: (cell: UITableViewCell) -> Void) -> CGFloat
}

public class PrototypeHeightStrategy {

    public weak var tableView: UITableView?
    private var cachedHeights = [Int: CGFloat]()
    
    public func height(indexPath: NSIndexPath, reusableIdentifier: String, configure: (cell: UITableViewCell) -> Void) -> CGFloat {
        
        guard let cell = tableView?.dequeueReusableCellWithIdentifier(reusableIdentifier) else { return 0 }
        
        cell.bounds = CGRectMake(0, 0, tableView?.bounds.size.width ?? 0, cell.bounds.height)
        
        configure(cell: cell)
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        return cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 1
    }
}