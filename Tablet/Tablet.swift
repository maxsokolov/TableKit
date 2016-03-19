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

internal struct TabletNotifications {
    static let CellAction = "_cellaction"
}

/**
    The actions that Tablet provides.
*/
public enum ActionType {

    case click
    case select
    case deselect
    case willSelect
    case configure
    case willDisplay
    case shouldHighlight
    case height
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

public class ActionData<I, C> {

    public let cell: C?
    public let item: I
    public let itemIndex: Int
    public let indexPath: NSIndexPath
    
    init(cell: C?, indexPath: NSIndexPath, item: I, itemIndex: Int) {
        
        self.cell = cell
        self.indexPath = indexPath
        self.item = item
        self.itemIndex = itemIndex
    }
}

/**
    A custom action that you can trigger from your cell.
    You can eacily catch actions using a chaining manner with your row builder.
*/
public class Action {

    /// The cell that triggers an action.
    public let cell: UITableViewCell

    /// The action unique key.
    public let key: String

    /// The custom user info.
    public let userInfo: [NSObject: AnyObject]?

    public init(key: String, sender: UITableViewCell, userInfo: [NSObject: AnyObject]? = nil) {

        self.key = key
        self.cell = sender
        self.userInfo = userInfo
    }

    public func invoke() {

        NSNotificationCenter.defaultCenter().postNotificationName(TabletNotifications.CellAction, object: self)
    }
}

/**
    If you want to delegate your cell configuration logic to cell itself (with your view model or even model) than
    just provide an implementation of this protocol for your cell. Enjoy safe-typisation.
*/
public protocol ConfigurableCell {

    typealias Item

    static func reusableIdentifier() -> String
    static func estimatedHeight() -> Float
    func configureWithItem(item: Item)
}

public extension ConfigurableCell where Self: UITableViewCell {

    static func reusableIdentifier() -> String {

        return NSStringFromClass(self).componentsSeparatedByString(".").last ?? ""
    }
}

/**
    A protocol that every row builder should follow. 
    A certain section can only works with row builders that respect this protocol.
*/
public protocol RowBuilder {

    var numberOfRows: Int { get }
    var reusableIdentifier: String { get }
    var estimatedRowHeight: Float { get }

    func registerCell(inTableView tableView: UITableView)
    func invokeAction(actionType: ActionType, cell: UITableViewCell?, indexPath: NSIndexPath, itemIndex: Int, userInfo: [NSObject: AnyObject]?) -> AnyObject?
}