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
    public private(set) var sections = [TableSection]()
    
    private weak var scrollDelegate: UIScrollViewDelegate?
    private var heightStrategy: CellHeightCalculatable?
    private var cellRegisterer: TableCellRegisterer?
    
    public var shouldUsePrototypeCellHeightCalculation: Bool = false {
        didSet {
            if shouldUsePrototypeCellHeightCalculation {
                heightStrategy = PrototypeHeightStrategy(tableView: tableView)
            }
        }
    }
    
    public var isEmpty: Bool {
        return sections.isEmpty
    }
    
    public init(tableView: UITableView, scrollDelegate: UIScrollViewDelegate? = nil, shouldUseAutomaticCellRegistration: Bool = true) {
        super.init()
        
        if shouldUseAutomaticCellRegistration {
            self.cellRegisterer = TableCellRegisterer(tableView: tableView)
        }
        
        self.scrollDelegate = scrollDelegate
        self.tableView = tableView
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didReceiveAction), name: TableKitNotifications.CellAction, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    public func reload() {
        tableView?.reloadData()
    }
    
    // MARK: Public
    
    public func invoke(action action: TableRowActionType, cell: UITableViewCell?, indexPath: NSIndexPath) -> Any? {
        return sections[indexPath.section].rows[indexPath.row].invoke(action, cell: cell, path: indexPath)
    }
    
    public override func respondsToSelector(selector: Selector) -> Bool {
        return super.respondsToSelector(selector) || scrollDelegate?.respondsToSelector(selector) == true
    }
    
    public override func forwardingTargetForSelector(selector: Selector) -> AnyObject? {
        return scrollDelegate?.respondsToSelector(selector) == true ? scrollDelegate : super.forwardingTargetForSelector(selector)
    }
    
    // MARK: - Internal -
    
    func hasAction(action: TableRowActionType, atIndexPath indexPath: NSIndexPath) -> Bool {
        return sections[indexPath.section].rows[indexPath.row].hasAction(action)
    }
    
    func didReceiveAction(notification: NSNotification) {
        
        guard let action = notification.object as? TableCellAction, indexPath = tableView?.indexPathForCell(action.cell) else { return }
        invoke(action: .custom(action.key), cell: action.cell, indexPath: indexPath)
    }
    
    // MARK: - Height
    
    public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let row = sections[indexPath.section].rows[indexPath.row]

        cellRegisterer?.register(cellType: row.cellType, forCellReuseIdentifier: row.reuseIdentifier)

        return row.estimatedHeight ?? heightStrategy?.estimatedHeight(row, path: indexPath) ?? UITableViewAutomaticDimension
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let row = sections[indexPath.section].rows[indexPath.row]

        let rowHeight = invoke(action: .height, cell: nil, indexPath: indexPath) as? CGFloat

        return rowHeight ?? row.defaultHeight ?? heightStrategy?.height(row, path: indexPath) ?? UITableViewAutomaticDimension
    }
    
    // MARK: UITableViewDataSource - configuration
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].numberOfRows
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = sections[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(row.reuseIdentifier, forIndexPath: indexPath)
        
        if cell.frame.size.width != tableView.frame.size.width {
            cell.frame = CGRectMake(0, 0, tableView.frame.size.width, cell.frame.size.height)
            cell.layoutIfNeeded()
        }
        
        row.configure(cell)
        invoke(action: .configure, cell: cell, indexPath: indexPath)
        
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
        
        let section = sections[section]
        return section.headerHeight ?? section.headerView?.frame.size.height ?? 0
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        let section = sections[section]
        return section.footerHeight ?? section.footerView?.frame.size.height ?? 0
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
    
    public func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if hasAction(.willSelect, atIndexPath: indexPath) {
            return invoke(action: .willSelect, cell: tableView.cellForRowAtIndexPath(indexPath), indexPath: indexPath) as? NSIndexPath
        }
        return indexPath
    }
    
    // MARK: - Row editing -
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return sections[indexPath.section].rows[indexPath.row].isEditingAllowed(forIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return sections[indexPath.section].rows[indexPath.row].editingActions
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            invoke(action: .clickDelete, cell: tableView.cellForRowAtIndexPath(indexPath), indexPath: indexPath)
        }
    }
    
    // MARK: - Sections manipulation -
    
    public func append(section section: TableSection) -> Self {
        
        append(sections: [section])
        return self
    }
    
    public func append(sections sections: [TableSection]) -> Self {
        
        self.sections.appendContentsOf(sections)
        return self
    }
    
    public func append(rows rows: [Row]) -> Self {
        
        append(section: TableSection(rows: rows))
        return self
    }
    
    public func insert(section section: TableSection, atIndex index: Int) -> Self {
        
        sections.insert(section, atIndex: index)
        return self
    }
    
    public func delete(index index: Int) -> Self {
        
        sections.removeAtIndex(index)
        return self
    }
    
    public func clear() -> Self {
        
        sections.removeAll()
        return self
    }
}