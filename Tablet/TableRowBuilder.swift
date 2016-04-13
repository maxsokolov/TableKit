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

public typealias ReturnValue = AnyObject?

enum ActionHandler<I, C> {
    
    case actionBlock((data: ActionData<I, C>) -> Void)
    case actionReturnBlock((data: ActionData<I, C>) -> AnyObject?)
    
    func invoke(data: ActionData<I, C>) -> ReturnValue {
        
        switch (self) {
        case .actionBlock(let closure):
            closure(data: data)
            return true
        case .actionReturnBlock(let closure):
            return closure(data: data)
        }
    }
}

public class RowBuilder : NSObject {
    
    public private(set) var reusableIdentifier: String
    public var numberOfRows: Int {
        return 0
    }
    public var estimatedRowHeight: Float {
        return 44
    }
    
    init(id: String) {
        reusableIdentifier = id
    }
    
    // MARK: internal methods, must be overriden in subclass
    
    func invokeAction(actionType: ActionType, cell: UITableViewCell?, indexPath: NSIndexPath, itemIndex: Int, userInfo: [NSObject: AnyObject]?) -> AnyObject? {
        return nil
    }
    
    func registerCell(inTableView tableView: UITableView) {
    }
}

/**
 Responsible for building cells of given type and passing items to them.
 */
public class TableRowBuilder<I, C where C: UITableViewCell> : RowBuilder {
    
    private var actions = Dictionary<String, ActionHandler<I, C>>()
    private var items = [I]()
    
    public override var numberOfRows: Int {
        return items.count
    }
    
    public init(item: I, id: String? = nil) {
        super.init(id: id ?? NSStringFromClass(C).componentsSeparatedByString(".").last ?? "")
        
        items.append(item)
    }
    
    public init(items: [I]? = nil, id: String? = nil) {
        super.init(id: id ?? NSStringFromClass(C).componentsSeparatedByString(".").last ?? "")
        
        if items != nil {
            self.items.appendContentsOf(items!)
        }
    }
    
    // MARK: Chaining actions
    
    public func action(key: String, closure: (data: ActionData<I, C>) -> Void) -> Self {
        
        actions[key] = .actionBlock(closure)
        return self
    }
    
    public func action(actionType: ActionType, closure: (data: ActionData<I, C>) -> Void) -> Self {
        
        actions[actionType.key] = .actionBlock(closure)
        return self
    }
    
    public func action(actionType: ActionType, closure: (data: ActionData<I, C>) -> ReturnValue) -> Self {
        
        actions[actionType.key] = .actionReturnBlock(closure)
        return self
    }
    
    // MARK: Internal
    
    override func invokeAction(actionType: ActionType, cell: UITableViewCell?, indexPath: NSIndexPath, itemIndex: Int, userInfo: [NSObject: AnyObject]?) -> AnyObject? {
        
        if let action = actions[actionType.key] {
            return action.invoke(ActionData(cell: cell as? C, indexPath: indexPath, item: items[itemIndex], itemIndex: itemIndex, userInfo: userInfo))
        }
        return nil
    }
    
    override func registerCell(inTableView tableView: UITableView) {
        
        if tableView.dequeueReusableCellWithIdentifier(reusableIdentifier) != nil {
            return
        }
        
        guard let resource = NSStringFromClass(C).componentsSeparatedByString(".").last else { return }
        
        let bundle = NSBundle(forClass: C.self)
        
        if let _ = bundle.pathForResource(resource, ofType: "nib") { // existing cell
            
            tableView.registerNib(UINib(nibName: resource, bundle: bundle), forCellReuseIdentifier: reusableIdentifier)
            
        } else {
            
            tableView.registerClass(C.self, forCellReuseIdentifier: reusableIdentifier)
        }
    }
}

/**
 Responsible for building configurable cells of given type and passing items to them.
 */
public class TableConfigurableRowBuilder<I, C: ConfigurableCell where C.T == I, C: UITableViewCell> : TableRowBuilder<I, C> {
    
    public override var estimatedRowHeight: Float {
        return C.estimatedHeight()
    }
    
    public init(item: I) {
        super.init(item: item, id: C.reusableIdentifier())
    }
    
    public init(items: [I]? = nil) {
        super.init(items: items, id: C.reusableIdentifier())
    }
    
    override func invokeAction(actionType: ActionType, cell: UITableViewCell?, indexPath: NSIndexPath, itemIndex: Int, userInfo: [NSObject: AnyObject]?) -> AnyObject? {
        
        switch actionType {
        case .configure:
            (cell as? C)?.configure(items[itemIndex])
        default: break
        }
        return super.invokeAction(actionType, cell: cell, indexPath: indexPath, itemIndex: itemIndex, userInfo: userInfo)
    }
}

public extension TableRowBuilder {
    
    // MARK: Items manipulation
    
    public func append(items items: [I]) {
        self.items.appendContentsOf(items)
    }
    
    public func clear() {
        items.removeAll()
    }
}

public func +=<I, C>(left: TableRowBuilder<I, C>, right: I) {
    left.append(items: [right])
}

public func +=<I, C>(left: TableRowBuilder<I, C>, right: [I]) {
    left.append(items: right)
}