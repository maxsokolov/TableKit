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
    Responsible for table view's datasource and delegate.
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

    // MARK: Private methods
    
    /**
        Find a row builder that responsible for building a row from cell with given item type.
    
        - Parameters:
        - indexPath: path of cell to dequeue
    
        - Returns: A touple - (builder, builderItemIndex)
    */
    private func builderAtIndexPath(indexPath: NSIndexPath) -> (RowBuilder, Int) {
        
        return sections[indexPath.section].builderAtIndex(indexPath.row)!
    }
    
    public func invokeAction(action: ActionType, cell: UITableViewCell?, indexPath: NSIndexPath) -> AnyObject? {
        
        let builder = builderAtIndexPath(indexPath)
        return builder.0.invokeAction(action, cell: cell, indexPath: indexPath, itemIndex: builder.1, userInfo: nil)
    }
    
    internal func didReceiveAction(notification: NSNotification) {
        
        if let action = notification.object as? Action, indexPath = tableView.indexPathForCell(action.cell) {
            
            let builder = builderAtIndexPath(indexPath)
            builder.0.invokeAction(.custom(action.key), cell: action.cell, indexPath: indexPath, itemIndex: builder.1, userInfo: action.userInfo)
        }
    }
}

public extension TableDirector {
 
    // MARK: UITableViewDataSource - configuration
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].numberOfRowsInSection
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let builder = builderAtIndexPath(indexPath)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(builder.0.reusableIdentifier, forIndexPath: indexPath)
        
        builder.0.invokeAction(.configure, cell: cell, indexPath: indexPath, itemIndex: builder.1, userInfo: nil)
        
        return cell
    }
}

public extension TableDirector {

    // MARK: UITableViewDataSource - section setup
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section].headerTitle
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return sections[section].footerTitle
    }
    
    // MARK: UITableViewDelegate - section setup
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return sections[section].headerView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return sections[section].footerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return sections[section].headerHeight
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return sections[section].footerHeight
    }
}

public extension TableDirector {

    // MARK: UITableViewDelegate - actions

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return builderAtIndexPath(indexPath).0.estimatedRowHeight
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return invokeAction(.height, cell: nil, indexPath: indexPath) as? CGFloat ?? UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if invokeAction(.click, cell: cell, indexPath: indexPath) != nil {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else {
            invokeAction(.select, cell: cell, indexPath: indexPath)
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {

        invokeAction(.deselect, cell: tableView.cellForRowAtIndexPath(indexPath), indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        invokeAction(.willDisplay, cell: cell, indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {

        return invokeAction(.shouldHighlight, cell: tableView.cellForRowAtIndexPath(indexPath), indexPath: indexPath) as? Bool ?? true
    }
}

extension TableDirector {

    // MARK: Sections manipulation

    public func appendSection(section: TableSectionBuilder) {
        appendSections([section])
    }
    
    public func appendSections(sections: [TableSectionBuilder]) {

        sections.forEach { $0.willMoveToDirector(tableView) }
        self.sections.appendContentsOf(sections)
    }
}

public func +=(left: TableDirector, right: RowBuilder) {

    left.appendSection(TableSectionBuilder(rowBuilders: [right]))
}

public func +=(left: TableDirector, right: [RowBuilder]) {
    
    left.appendSection(TableSectionBuilder(rowBuilders: right))
}

public func +=(left: TableDirector, right: TableSectionBuilder) {

    left.appendSection(right)
}

public func +=(left: TableDirector, right: [TableSectionBuilder]) {
    
    left.appendSections(right)
}