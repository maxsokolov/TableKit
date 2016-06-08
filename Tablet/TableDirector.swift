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

/**
    Responsible for table view's datasource and delegate.
 */
public class TableDirector: NSObject, UITableViewDataSource, UITableViewDelegate {

    public private(set) weak var tableView: UITableView?
    private weak var scrollDelegate: UIScrollViewDelegate?
    public private(set) var sections = [TableSection]()

    public init(tableView: UITableView, scrollDelegate: UIScrollViewDelegate? = nil) {
        super.init()

        self.scrollDelegate = scrollDelegate
        self.tableView = tableView
        self.tableView?.delegate = self
        self.tableView?.dataSource = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didReceiveAction), name: TabletNotifications.CellAction, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    public func reload() {
        tableView?.reloadData()
    }

    // MARK: Public
    
    public func invoke(action action: ActionType, cell: UITableViewCell?, indexPath: NSIndexPath) -> AnyObject? {
        
        return nil
    }

    public override func respondsToSelector(selector: Selector) -> Bool {
        return super.respondsToSelector(selector) || scrollDelegate?.respondsToSelector(selector) == true
    }

    public override func forwardingTargetForSelector(selector: Selector) -> AnyObject? {
        return scrollDelegate?.respondsToSelector(selector) == true ? scrollDelegate : super.forwardingTargetForSelector(selector)
    }
    
    // MARK: - Internal -
    
    func didReceiveAction(notification: NSNotification) {
        
        if let action = notification.object as? Action, indexPath = tableView?.indexPathForCell(action.cell) {
            
            //let builder = builderAtIndexPath(indexPath)
            //builder.0.invoke(action: .custom(action.key), cell: action.cell, indexPath: indexPath, itemIndex: builder.1, userInfo: notification.userInfo)
        }
    }
    
    // MARK: - Height
    
    public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return sections[indexPath.section].items[indexPath.row].estimatedHeight
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return UITableViewAutomaticDimension
    }
    
    // MARK: UITableViewDataSource - configuration
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].numberOfRowsInSection
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let row = sections[indexPath.section].items[indexPath.row]

        let cell = tableView.dequeueReusableCellWithIdentifier(row.reusableIdentifier, forIndexPath: indexPath)
        
        if cell.frame.size.width != tableView.frame.size.width {
            cell.frame = CGRectMake(0, 0, tableView.frame.size.width, cell.frame.size.height)
            cell.layoutIfNeeded()
        }

        row.configure(cell)

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
        return sections[section].headerView?.frame.size.height ?? UITableViewAutomaticDimension
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections[section].footerView?.frame.size.height ?? UITableViewAutomaticDimension
    }
    
    // MARK: UITableViewDelegate - actions
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if invoke(action: .click, cell: cell, indexPath: indexPath) != nil {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else {
            invoke(action: .select, cell: cell, indexPath: indexPath)
        }
    }
    
    public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        invoke(action: .deselect, cell: tableView.cellForRowAtIndexPath(indexPath), indexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        invoke(action: .willDisplay, cell: cell, indexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return invoke(action: .shouldHighlight, cell: tableView.cellForRowAtIndexPath(indexPath), indexPath: indexPath) as? Bool ?? true
    }
    
    /*func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
     
     return invokeAction(.willSelect, cell: tableView.cellForRowAtIndexPath(indexPath), indexPath: indexPath) as? NSIndexPath
     }*/
    
    // MARK: - Sections manipulation -
    
    public func append(section section: TableSection) {
        append(sections: [section])
    }
    
    public func append(sections sections: [TableSection]) {
        
        sections.forEach { $0.tableDirector = self }
        self.sections.appendContentsOf(sections)
    }
    
    public func clear() {
        sections.removeAll()
    }
}