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
open class TableDirector: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    open fileprivate(set) weak var tableView: UITableView?
    open fileprivate(set) var sections = [TableSection]()
    
    fileprivate weak var scrollDelegate: UIScrollViewDelegate?
    fileprivate var heightStrategy: CellHeightCalculatable?
    fileprivate var cellRegisterer: TableCellRegisterer?
    
    open var shouldUsePrototypeCellHeightCalculation: Bool = false {
        didSet {
            if shouldUsePrototypeCellHeightCalculation {
                heightStrategy = PrototypeHeightStrategy(tableView: tableView)
            }
        }
    }
    
    open var isEmpty: Bool {
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveAction), name: NSNotification.Name(rawValue: TableKitNotifications.CellAction), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open func reload() {
        tableView?.reloadData()
    }
    
    // MARK: Public
    
    open func invoke(action: TableRowActionType, cell: UITableViewCell?, indexPath: IndexPath) -> Any? {
        return sections[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row].invoke(action, cell: cell, path: indexPath)
    }
    
    open override func responds(to selector: Selector) -> Bool {
        return super.responds(to: selector) || scrollDelegate?.responds(to: selector) == true
    }
    
    open override func forwardingTarget(for selector: Selector) -> Any? {
        return scrollDelegate?.responds(to: selector) == true ? scrollDelegate : super.forwardingTarget(for: selector)
    }
    
    // MARK: - Internal -
    
    func hasAction(_ action: TableRowActionType, atIndexPath indexPath: IndexPath) -> Bool {
        return sections[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row].hasAction(action)
    }
    
    func didReceiveAction(_ notification: Notification) {
        
        guard let action = notification.object as? TableCellAction, let indexPath = tableView?.indexPath(for: action.cell) else { return }
        let _ = invoke(action: .custom(action.key), cell: action.cell, indexPath: indexPath)
    }
    
    // MARK: - Height
    
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let row = sections[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row]

        cellRegisterer?.register(cellType: row.cellType, forCellReuseIdentifier: row.reuseIdentifier)

        return row.estimatedHeight ?? heightStrategy?.estimatedHeight(row, path: indexPath) ?? UITableViewAutomaticDimension
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let row = sections[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row]

        let rowHeight = invoke(action: .height, cell: nil, indexPath: indexPath) as? CGFloat

        return rowHeight ?? row.defaultHeight ?? heightStrategy?.height(row, path: indexPath) ?? UITableViewAutomaticDimension
    }
    
    // MARK: UITableViewDataSource - configuration
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].numberOfRows
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = sections[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier, for: indexPath)
        
        if cell.frame.size.width != tableView.frame.size.width {
            cell.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: cell.frame.size.height)
            cell.layoutIfNeeded()
        }
        
        row.configure(cell)
        let _ = invoke(action: .configure, cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    // MARK: UITableViewDataSource - section setup
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
    }
    
    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footerTitle
    }
    
    // MARK: UITableViewDelegate - section setup
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].headerView
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sections[section].footerView
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let section = sections[section]
        return section.headerHeight ?? section.headerView?.frame.size.height ?? 0
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        let section = sections[section]
        return section.footerHeight ?? section.footerView?.frame.size.height ?? 0
    }
    
    // MARK: UITableViewDelegate - actions
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if invoke(action: .click, cell: cell, indexPath: indexPath) != nil {
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            let _ = invoke(action: .select, cell: cell, indexPath: indexPath)
        }
    }
    
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let _ = invoke(action: .deselect, cell: tableView.cellForRow(at: indexPath), indexPath: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let _ = invoke(action: .willDisplay, cell: cell, indexPath: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return invoke(action: .shouldHighlight, cell: tableView.cellForRow(at: indexPath), indexPath: indexPath) as? Bool ?? true
    }
    
    open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if hasAction(.willSelect, atIndexPath: indexPath) {
            return invoke(action: .willSelect, cell: tableView.cellForRow(at: indexPath), indexPath: indexPath) as? IndexPath
        }
        return indexPath
    }
    
    // MARK: - Row editing -
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return sections[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row].isEditingAllowed(forIndexPath: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return sections[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row].editingActions
    }
    
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let _ = invoke(action: .clickDelete, cell: tableView.cellForRow(at: indexPath), indexPath: indexPath)
        }
    }
    
    // MARK: - Sections manipulation -
    
    open func append(section: TableSection) -> Self {
        
        let _ = append(sections: [section])
        return self
    }
    
    open func append(sections: [TableSection]) -> Self {
        
        self.sections.append(contentsOf: sections)
        return self
    }
    
    open func append(rows: [Row]) -> Self {
        
        let _ = append(section: TableSection(rows: rows))
        return self
    }
    
    open func insert(section: TableSection, atIndex index: Int) -> Self {
        
        sections.insert(section, at: index)
        return self
    }
    
    open func delete(index: Int) -> Self {
        
        sections.remove(at: index)
        return self
    }
    
    open func clear() -> Self {
        
        sections.removeAll()
        return self
    }
}
