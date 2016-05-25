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

public class TablePrototypeRowBuilder<DataType: Hashable, CellType: ConfigurableCell where CellType.T == DataType, CellType: UITableViewCell> : TableBaseRowBuilder<DataType, CellType> {
    
    private var cachedHeights = [Int: CGFloat]()
    private var prototypeCell: CellType?
    
    public init(item: DataType) {
        super.init(item: item, id: CellType.reusableIdentifier())
    }
    
    public init(items: [DataType]? = nil) {
        super.init(items: items, id: CellType.reusableIdentifier())
    }
    
    public override func estimatedRowHeight() -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func heightCall(item: DataType, width: CGFloat) -> CGFloat {
        
        guard let cell = prototypeCell else { return 0 }
        
        cell.bounds = CGRectMake(0, 0, width, cell.bounds.height)
        
        cell.configure(item)
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        return cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 1
    }
    
    // прехит по мере скроллинга в бэк
    // прехит не должен прехитить то что уже есть (показанное)
    // по мере скроллинга уметь отменять перхит ()
    
    public override func rowHeight(index: Int) -> CGFloat {
        
        guard let cell = prototypeCell else { return 0 }
        
        let itemz = item(index: index)
        
        if let height = cachedHeights[itemz.hashValue] {
            return height
        }
        
        let height = heightCall(itemz, width: tableDirector?.tableView?.bounds.size.width ?? 0)
        
        cachedHeights[itemz.hashValue] = height
        
        print(tableDirector?.tableView?.bounds.size.width, cell.bounds.height, height)
        
        return height
    }
    
    public func preheat(item: DataType) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let height = self.heightCall(item, width: 0)
            
            // check if actual height exists
            // calc height
            
            //let heights = self.items.map { self.heightZ($0) }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                
                // check if table width is actual
                // store height in cache
            }
        }
    }
    
    public override func invoke(action action: ActionType, cell: UITableViewCell?, indexPath: NSIndexPath, itemIndex: Int, userInfo: [NSObject: AnyObject]?) -> AnyObject? {
        
        if case .configure = action {
            
            (cell as? CellType)?.configure(item(index: itemIndex))
        }
        return super.invoke(action: action, cell: cell, indexPath: indexPath, itemIndex: itemIndex, userInfo: userInfo)
    }
    
    public override func willUpdateDirector(director: TableDirector?) {
        
        //tableDirector = director
        if let tableView = director?.tableView, cell = tableView.dequeueReusableCellWithIdentifier(reusableIdentifier) as? CellType {
            prototypeCell = cell
        }
    }
}