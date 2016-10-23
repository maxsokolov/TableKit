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

struct TableKitNotifications {
    static let CellAction = "TableKitNotificationsCellAction"
}

public protocol RowConfigurable {
    
    func configure(_ cell: UITableViewCell)
}

public protocol RowActionable {
    
    var editingActions: [UITableViewRowAction]? { get }
    func isEditingAllowed(forIndexPath indexPath: IndexPath) -> Bool

    func invoke(action: TableRowActionType, cell: UITableViewCell?, path: IndexPath, userInfo: [AnyHashable: Any]?) -> Any?
    func has(action: TableRowActionType) -> Bool
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

public enum TableRowActionType {
    
    case click
    case clickDelete
    case select
    case deselect
    case willSelect
    case willDisplay
    case shouldHighlight
    case height
    case canEdit
    case configure
    case custom(String)
    
    var key: String {
        
        switch (self) {
        case .custom(let key):
            return key
        default:
            return "_\(self)"
        }
    }
}

public protocol RowHeightCalculator {
    
    func height(forRow row: Row, at indexPath: IndexPath) -> CGFloat
    func estimatedHeight(forRow row: Row, at indexPath: IndexPath) -> CGFloat
    
    func invalidate()
}
