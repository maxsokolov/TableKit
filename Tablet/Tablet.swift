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

internal let kActionPerformedNotificationKey = "_action"

/**
    Built in actions that Tablet provides.
*/
public enum ActionType : String {

    case click = "_click"
    case select = "_select"
    case deselect = "_deselect"
    case configure = "_configure"
    case willDisplay = "_willDisplay"
}

public struct ActionData<I, C> {

    public let cell: C
    public let item: I
    public let itemIndex: Int
    public let indexPath: NSIndexPath
    
    init(cell: C, indexPath: NSIndexPath, item: I, itemIndex: Int) {
        
        self.cell = cell
        self.indexPath = indexPath
        self.item = item
        self.itemIndex = itemIndex
    }
}

public class Action {

    public let cell: UITableViewCell
    public let key: String
    public let userInfo: [NSObject: AnyObject]?

    public init(key: String, sender: UITableViewCell, userInfo: [NSObject: AnyObject]? = nil) {
        self.key = key
        self.cell = sender
        self.userInfo = userInfo
    }

    public func trigger() {

        NSNotificationCenter.defaultCenter().postNotificationName(kActionPerformedNotificationKey, object: self)
    }
}

/**
    If you want to delegate your cell configuration logic to cell itself (with your view model or even model) than
    just provide an implementation of this protocol for your cell. Enjoy strong typisation.
*/
public protocol ConfigurableCell {

    typealias Item

    static func reusableIdentifier() -> String
    func configureWithItem(item: Item)
}

/**
    A protocol that every row builder should follow. 
    A certain section can only works with row builders that respect this protocol.
*/
public protocol ReusableRowBuilder {

    var numberOfRows: Int { get }
    var reusableIdentifier: String { get }

    func triggerAction(key: String, cell: UITableViewCell, indexPath: NSIndexPath, itemIndex: Int) -> Bool
}

/**
    A class that responsible for building cells of given type and passing items to them.
*/
public class TableRowBuilder<I, C where C: UITableViewCell> : ReusableRowBuilder {

    public typealias TableRowBuilderActionBlock = (data: ActionData<I, C>) -> Void
    
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
    
    // MARK: Triggers

    public func triggerAction(key: String, cell: UITableViewCell, indexPath: NSIndexPath, itemIndex: Int) -> Bool {

        let actionData = ActionData(cell: cell as! C, indexPath: indexPath, item: items[itemIndex], itemIndex: itemIndex)

        if let block = actions[key] {
            block(data: actionData)
            return true
        }
        return false
    }
}

/**
    A class that responsible for building configurable cells of given type and passing items to them.
*/
public class TableConfigurableRowBuilder<I, C: ConfigurableCell where C.Item == I, C: UITableViewCell> : TableRowBuilder<I, C>  {

    public init(item: I) {
        super.init(item: item, id: C.reusableIdentifier())
    }

    public init(items: [I]? = nil) {
        super.init(items: items, id: C.reusableIdentifier())
    }
    
    public override func triggerAction(key: String, cell: UITableViewCell, indexPath: NSIndexPath, itemIndex: Int) -> Bool {

        (cell as! C).configureWithItem(items[itemIndex])
        
        return super.triggerAction(key, cell: cell, indexPath: indexPath, itemIndex: itemIndex)
    }
}

/**
    A class that responsible for building a certain table view section.
*/
public class TableSectionBuilder {

    private var builders = [ReusableRowBuilder]()

    public var headerTitle: String?
    public var footerTitle: String?

    public var headerView: UIView?
    public var headerHeight: CGFloat = UITableViewAutomaticDimension
    
    public var footerView: UIView?
    public var footerHeight: CGFloat = UITableViewAutomaticDimension

    /// A total number of rows in section of each row builder.
    public var numberOfRowsInSection: Int {

        var number = 0
        for builder in builders {
            number += builder.numberOfRows
        }
        return number
    }

    public init(headerTitle: String? = nil, footerTitle: String? = nil, rowBuilders: [ReusableRowBuilder]? = nil) {

        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        
        if let initialRows = rowBuilders {
            self.builders.appendContentsOf(initialRows)
        }
    }

    public init(headerView: UIView? = nil, headerHeight: CGFloat = UITableViewAutomaticDimension, footerView: UIView? = nil, footerHeight: CGFloat = UITableViewAutomaticDimension) {

        self.headerView = headerView
        self.headerHeight = headerHeight

        self.footerView = footerView
        self.footerHeight = footerHeight
    }

    internal func builderAtIndex(var index: Int) -> (ReusableRowBuilder, Int)? {

        for builder in builders {
            if index < builder.numberOfRows {
                return (builder, index)
            }
            index -= builder.numberOfRows
        }

        return nil
    }
}

/**
    A class that actualy handles table view's datasource and delegate.
*/
public class TableDirector: NSObject, UITableViewDataSource, UITableViewDelegate {

    private weak var tableView: UITableView!
    private var sections = [TableSectionBuilder]()

    public init(tableView: UITableView) {
        super.init()

        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveAction:", name: kActionPerformedNotificationKey, object: nil)
    }
    
    deinit {

        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: Public methods

    public func appendSection(section: TableSectionBuilder) {
        sections.append(section)
    }

    public func appendSections(sections: [TableSectionBuilder]) {
        self.sections.appendContentsOf(sections)
    }

    // MARK: Private methods

    /**
        Find a row builder that responsible for building a row from cell with given item type.

        - Parameters:
        - indexPath: path of cell to dequeue
    
        - Returns: A touple - (builder, builderItemIndex)
    */
    private func builderAtIndexPath(indexPath: NSIndexPath) -> (ReusableRowBuilder, Int) {

        return sections[indexPath.section].builderAtIndex(indexPath.row)!
    }
    
    private func triggerAction(action: ActionType, cell: UITableViewCell?, indexPath: NSIndexPath) -> Bool {
        
        let builder = builderAtIndexPath(indexPath)
        return builder.0.triggerAction(action.rawValue, cell: cell!, indexPath: indexPath, itemIndex: builder.1)
    }
    
    internal func didReceiveAction(notification: NSNotification) {

        if let action = notification.object as? Action,
            indexPath = tableView.indexPathForCell(action.cell) {

            let builder = builderAtIndexPath(indexPath)
            builder.0.triggerAction(action.key, cell: action.cell, indexPath: indexPath, itemIndex: builder.1)
        }
    }

    // MARK: UITableViewDataSource - configuration

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return sections.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return sections[section].numberOfRowsInSection
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let builder = builderAtIndexPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(builder.0.reusableIdentifier, forIndexPath: indexPath)

        builder.0.triggerAction(ActionType.configure.rawValue, cell: cell, indexPath: indexPath, itemIndex: builder.1)

        return cell
    }
    
    // MARK: UITableViewDataSource - section setup
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section].headerTitle
    }
    
    public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return sections[section].footerTitle
    }
    
    // MARK: UITableViewDelegate - section setup
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        return sections[section].headerView
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        return sections[section].footerView
    }

    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return sections[section].headerHeight
    }

    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        return sections[section].footerHeight
    }

    // MARK: UITableViewDelegate - actions
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if triggerAction(.click, cell: cell, indexPath: indexPath) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else {
            triggerAction(.select, cell: cell, indexPath: indexPath)
        }
    }

    public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {

        triggerAction(.deselect, cell: tableView.cellForRowAtIndexPath(indexPath), indexPath: indexPath)
    }

    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        triggerAction(.willDisplay, cell: cell, indexPath: indexPath)
    }
}