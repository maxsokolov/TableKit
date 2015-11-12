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
import Foundation

/**
    Responsible for building cells of given type and passing items to them.
*/
public class TableRowBuilder<I, C where C: UITableViewCell> : RowBuilder {
    
    public typealias ReturnValue = AnyObject
    
    public typealias TableRowBuilderActionBlock = (data: ActionData<I, C>) -> Void
    public typealias TableRowBuilderReturnValueActionBlock = (data: ActionData<I, C>) -> ReturnValue
    
    private var actions = Dictionary<String, TableRowBuilderActionBlock>()
    private var items = [I]()
    
    public var reusableIdentifier: String
    public var numberOfRows: Int {
        get {
            return items.count
        }
    }
    
    public init(item: I, id: String) {
        
        reusableIdentifier = id
        items.append(item)
    }
    
    public init(items: [I]? = nil, id: String) {
        
        reusableIdentifier = id
        
        if items != nil {
            self.items.appendContentsOf(items!)
        }
    }
    
    public func appendItems(items: [I]) {
        
        self.items.appendContentsOf(items)
    }
    
    public func clear() {
        
        items.removeAll()
    }
    
    // MARK: Chaining actions
    
    public func action(key: String, action: TableRowBuilderActionBlock) -> Self {
        
        actions[key] = action
        return self
    }
    
    public func action(key: ActionType, action: TableRowBuilderActionBlock) -> Self {
        
        actions[key.rawValue] = action
        return self
    }
    
    public func action(key: ActionType, action: TableRowBuilderReturnValueActionBlock) -> Self {
        
        
        return self
    }
    
    // MARK: Triggers
    
    public func triggerAction(key: String, cell: UITableViewCell, indexPath: NSIndexPath, itemIndex: Int) -> ActionResult {
        
        let actionData = ActionData(cell: cell as! C, indexPath: indexPath, item: items[itemIndex], itemIndex: itemIndex)
        
        if let block = actions[key] {
            block(data: actionData)
            return .Failure
        }
        return .Failure
    }
}

/**
    Responsible for building configurable cells of given type and passing items to them.
*/
public class TableConfigurableRowBuilder<I, C: ConfigurableCell where C.Item == I, C: UITableViewCell> : TableRowBuilder<I, C>  {

    public init(item: I) {
        super.init(item: item, id: C.reusableIdentifier())
    }
    
    public init(items: [I]? = nil) {
        super.init(items: items, id: C.reusableIdentifier())
    }
    
    public override func triggerAction(key: String, cell: UITableViewCell, indexPath: NSIndexPath, itemIndex: Int) -> ActionResult {
        
        (cell as! C).configureWithItem(items[itemIndex])
        
        return super.triggerAction(key, cell: cell, indexPath: indexPath, itemIndex: itemIndex)
    }
}
