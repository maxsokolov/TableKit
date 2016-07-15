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

public protocol RowConfigurable {

    func configure(cell: UITableViewCell, isPrototype: Bool)
}

public protocol RowActionable {

    func invoke(action: TableRowActionType, cell: UITableViewCell?, path: NSIndexPath) -> Any?
    func hasAction(action: TableRowActionType) -> Bool
}

public protocol RowHashable {
    
    var hashValue: Int { get }
}

public protocol Row: RowConfigurable, RowActionable, RowHashable {

    var reusableIdentifier: String { get }
    var estimatedHeight: CGFloat { get }
    var defaultHeight: CGFloat { get }
}

public class TableRow<ItemType, CellType: ConfigurableCell where CellType.T == ItemType, CellType: UITableViewCell>: Row {

    public let item: ItemType
    private lazy var actions = [String: TableRowAction<ItemType, CellType>]()
    
    public var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }

    public var reusableIdentifier: String {
        return CellType.reusableIdentifier()
    }
    
    public var estimatedHeight: CGFloat {
        return CellType.estimatedHeight()
    }

    public var defaultHeight: CGFloat {
        return CellType.defaultHeight() ?? UITableViewAutomaticDimension
    }
    
    public init(item: ItemType, actions: [TableRowAction<ItemType, CellType>]? = nil) {
        
        self.item = item
        actions?.forEach { self.actions[$0.type.key] = $0 }
    }

    // MARK: - RowConfigurable -
    
    public func configure(cell: UITableViewCell, isPrototype: Bool) {
        (cell as? CellType)?.configure(item, isPrototype: isPrototype)
    }
    
    // MARK: - RowActionable -

    public func invoke(action: TableRowActionType, cell: UITableViewCell?, path: NSIndexPath) -> Any? {
        return actions[action.key]?.invoke(item: item, cell: cell, path: path)
    }

    public func hasAction(action: TableRowActionType) -> Bool {
        return actions[action.key] != nil
    }
    
    // MARK: - actions -
    
    public func action(action: TableRowAction<ItemType, CellType>) -> Self {

        actions[action.type.key] = action
        return self
    }
    
    public func action<T>(type: TableRowActionType, handler: (data: TableRowActionData<ItemType, CellType>) -> T) -> Self {
        
        actions[type.key] = TableRowAction(type, handler: handler)
        return self
    }
}