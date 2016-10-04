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
    
    func configure(_ cell: UITableViewCell)
}

public protocol RowActionable {
    
    var editingActions: [UITableViewRowAction]? { get }
    func isEditingAllowed(forIndexPath indexPath: IndexPath) -> Bool
    
    func invoke(_ action: TableRowActionType, cell: UITableViewCell?, path: IndexPath) -> Any?
    func hasAction(_ action: TableRowActionType) -> Bool
}

public protocol RowHashable {
    
    var hashValue: Int { get }
}

public protocol Row: RowConfigurable, RowActionable, RowHashable {
    
    var reuseIdentifier: String { get }
    var cellType: AnyClass { get }
    
    var estimatedHeight: CGFloat? { get }
    var defaultHeight: CGFloat? { get }
}

open class TableRow<ItemType, CellType: ConfigurableCell>: Row where CellType.T == ItemType, CellType: UITableViewCell {
    
    open let item: ItemType
    private lazy var actions = [String: TableRowAction<ItemType, CellType>]()
    private(set) open var editingActions: [UITableViewRowAction]?
    
    open var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
    
    open var reuseIdentifier: String {
        return CellType.reuseIdentifier
    }
    
    open var estimatedHeight: CGFloat? {
        return CellType.estimatedHeight
    }
    
    open var defaultHeight: CGFloat? {
        return CellType.defaultHeight
    }
    
    open var cellType: AnyClass {
        return CellType.self
    }
    
    public init(item: ItemType, actions: [TableRowAction<ItemType, CellType>]? = nil, editingActions: [UITableViewRowAction]? = nil) {
        
        self.item = item
        self.editingActions = editingActions
        actions?.forEach { self.actions[$0.type.key] = $0 }
    }
    
    // MARK: - RowConfigurable -
    
    open func configure(_ cell: UITableViewCell) {
        (cell as? CellType)?.configure(with: item)
    }
    
    // MARK: - RowActionable -
    
    open func invoke(_ action: TableRowActionType, cell: UITableViewCell?, path: IndexPath) -> Any? {
        return actions[action.key]?.invoke(item: item, cell: cell, path: path)
    }
    
    open func hasAction(_ action: TableRowActionType) -> Bool {
        return actions[action.key] != nil
    }
    
    open func isEditingAllowed(forIndexPath indexPath: IndexPath) -> Bool {
        
        if actions[TableRowActionType.canEdit.key] != nil {
            return invoke(.canEdit, cell: nil, path: indexPath) as? Bool ?? false
        }
        return editingActions?.isEmpty == false || actions[TableRowActionType.clickDelete.key] != nil
    }
    
    // MARK: - actions -
    
    @discardableResult
    open func action(_ action: TableRowAction<ItemType, CellType>) -> Self {
        
        actions[action.type.key] = action
        return self
    }
    
    @discardableResult
    open func action<T>(_ type: TableRowActionType, handler: @escaping (_ data: TableRowActionData<ItemType, CellType>) -> T) -> Self {
        
        actions[type.key] = TableRowAction<ItemType, CellType>(type, handler: handler)
        return self
    }
}
