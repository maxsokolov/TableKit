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

public typealias ReturnValue = AnyObject?

/**
 Responsible for building cells of given type and passing items to them.
 */
public class TableBaseRowBuilder<DataType, CellType where CellType: UITableViewCell> : RowBuilder {
    
    public private(set) weak var tableDirector: TableDirector?
    
    private var actions = [String: ActionHandler<DataType, CellType>]()
    private var items = [DataType]()
    
    public let reusableIdentifier: String
    
    public var numberOfRows: Int {
        return items.count
    }

    public init(item: DataType, id: String? = nil) {

        reusableIdentifier = id ?? String(CellType)
        items.append(item)
    }
    
    public init(items: [DataType]? = nil, id: String? = nil) {

        reusableIdentifier = id ?? String(CellType)

        if let items = items {
            self.items.appendContentsOf(items)
        }
    }
    
    public func rowHeight(index: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func estimatedRowHeight(index: Int) -> CGFloat {
        return 44
    }
    
    // MARK: - Chaining actions -
    
    public func action(key: String, handler: (data: ActionData<DataType, CellType>) -> Void) -> Self {
        
        actions[key] = .Handler(handler)
        return self
    }
    
    public func action(type: ActionType, handler: (data: ActionData<DataType, CellType>) -> Void) -> Self {

        actions[type.key] = .Handler(handler)
        return self
    }
    
    public func valueAction(type: ActionType, handler: (data: ActionData<DataType, CellType>) -> ReturnValue) -> Self {
        
        actions[type.key] = .ValueHandler(handler)
        return self
    }

    public func invoke(action action: ActionType, cell: UITableViewCell?, indexPath: NSIndexPath, itemIndex: Int, userInfo: [NSObject: AnyObject]?) -> AnyObject? {
        
        if let action = actions[action.key] {
            return action.invoke(ActionData(cell: cell as? CellType, indexPath: indexPath, item: items[itemIndex], itemIndex: itemIndex, userInfo: userInfo))
        }
        return nil
    }

    private func registerCell(inTableView tableView: UITableView) {
        
        if tableView.dequeueReusableCellWithIdentifier(reusableIdentifier) != nil {
            return
        }
        
        let resource = String(CellType)
        let bundle = NSBundle(forClass: CellType.self)
        
        if let _ = bundle.pathForResource(resource, ofType: "nib") { // existing cell
            tableView.registerNib(UINib(nibName: resource, bundle: bundle), forCellReuseIdentifier: reusableIdentifier)
        } else {
            tableView.registerClass(CellType.self, forCellReuseIdentifier: reusableIdentifier)
        }
    }

    public func willUpdateDirector(director: TableDirector?) {
        tableDirector = director

        
    }
    
    // MARK: - Items manipulation -
    
    public func delete(indexes indexes: [Int], animated: UITableViewRowAnimation) -> Self {
        
        return self
    }
    
    public func insert(items: [DataType], atIndex index: Int, animated: UITableViewRowAnimation) -> Self {
        
        self.items.insertContentsOf(items, at: index)
        
        return self
    }
    
    public func move(indexes: [Int], toIndexes: [Int]) -> Self {
        
        return self
    }
    
    public func update(index index: Int, item: DataType, animated: UITableViewRowAnimation) -> Self {
        
        return self
    }
    
    public func item(index index: Int) -> DataType {
        return items[index]
    }
    
    public func append(items items: [DataType]) {
        self.items.appendContentsOf(items)
    }
    
    public func clear() {
        items.removeAll()
    }
}