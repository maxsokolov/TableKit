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
    private func builderAtIndexPath(indexPath: NSIndexPath) -> (RowBuilder, Int) {
        
        return sections[indexPath.section].builderAtIndex(indexPath.row)!
    }
    
    private func triggerAction(action: ActionType, cell: UITableViewCell?, indexPath: NSIndexPath) -> AnyObject? {
        
        let builder = builderAtIndexPath(indexPath)
        return builder.0.triggerAction(action, cell: cell, indexPath: indexPath, itemIndex: builder.1)
    }
    
    internal func didReceiveAction(notification: NSNotification) {
        
        if let action = notification.object as? Action, indexPath = tableView.indexPathForCell(action.cell) {
            
            let builder = builderAtIndexPath(indexPath)
            builder.0.triggerAction(.custom(action.key), cell: action.cell, indexPath: indexPath, itemIndex: builder.1)
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
        
        builder.0.triggerAction(.configure, cell: cell, indexPath: indexPath, itemIndex: builder.1)
        
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
        
        if triggerAction(.click, cell: cell, indexPath: indexPath) != nil {
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
    
    public func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {

        return triggerAction(.shouldHighlight, cell: tableView.cellForRowAtIndexPath(indexPath), indexPath: indexPath) as? Bool ?? true
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return triggerAction(.height, cell: nil, indexPath: indexPath) as? CGFloat ?? tableView.rowHeight
    }
}