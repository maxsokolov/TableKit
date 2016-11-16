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
    
    open private(set) weak var tableView: UITableView?
    open fileprivate(set) var sections = [TableSection]()
    
    private weak var scrollDelegate: UIScrollViewDelegate?
    private var cellRegisterer: TableCellRegisterer?
    public private(set) var rowHeightCalculator: RowHeightCalculator?

    @available(*, deprecated, message: "Produced incorrect behaviour")
    open var shouldUsePrototypeCellHeightCalculation: Bool = false {
        didSet {
            if shouldUsePrototypeCellHeightCalculation {
                rowHeightCalculator = TablePrototypeCellHeightCalculator(tableView: tableView)
            } else {
                rowHeightCalculator = nil
            }
        }
    }
    
    open var isEmpty: Bool {
        return sections.isEmpty
    }
    
    public init(tableView: UITableView, scrollDelegate: UIScrollViewDelegate? = nil, shouldUseAutomaticCellRegistration: Bool = true, cellHeightCalculator: RowHeightCalculator?) {
        super.init()
        
        if shouldUseAutomaticCellRegistration {
            self.cellRegisterer = TableCellRegisterer(tableView: tableView)
        }
        
        self.rowHeightCalculator = cellHeightCalculator
        self.scrollDelegate = scrollDelegate
        self.tableView = tableView
        self.tableView?.delegate = self
        self.tableView?.dataSource = self

        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveAction), name: NSNotification.Name(rawValue: TableKitNotifications.CellAction), object: nil)
    }
    
    public convenience init(tableView: UITableView, scrollDelegate: UIScrollViewDelegate? = nil, shouldUseAutomaticCellRegistration: Bool = true, shouldUsePrototypeCellHeightCalculation: Bool = false) {

        let heightCalculator: TablePrototypeCellHeightCalculator? = shouldUsePrototypeCellHeightCalculation ? TablePrototypeCellHeightCalculator(tableView: tableView) : nil
        
        self.init(tableView: tableView, scrollDelegate: scrollDelegate, shouldUseAutomaticCellRegistration: shouldUseAutomaticCellRegistration, cellHeightCalculator: heightCalculator)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open func reload() {
        tableView?.reloadData()
    }
    
    // MARK: Public
    
    @discardableResult
    open func invoke(action: TableRowActionType, cell: UITableViewCell?, indexPath: IndexPath, userInfo: [AnyHashable: Any]? = nil) -> Any? {
        return sections[indexPath.section].rows[indexPath.row].invoke(action: action, cell: cell, path: indexPath, userInfo: userInfo)
    }
    
    open override func responds(to selector: Selector) -> Bool {
        return super.responds(to: selector) || scrollDelegate?.responds(to: selector) == true
    }
    
    open override func forwardingTarget(for selector: Selector) -> Any? {
        return scrollDelegate?.responds(to: selector) == true ? scrollDelegate : super.forwardingTarget(for: selector)
    }
    
    // MARK: - Internal
    
    func hasAction(_ action: TableRowActionType, atIndexPath indexPath: IndexPath) -> Bool {
        return sections[indexPath.section].rows[indexPath.row].has(action: action)
    }
    
    func didReceiveAction(_ notification: Notification) {
        
        guard let action = notification.object as? TableCellAction, let indexPath = tableView?.indexPath(for: action.cell) else { return }
        invoke(action: .custom(action.key), cell: action.cell, indexPath: indexPath, userInfo: notification.userInfo)
    }
    
    // MARK: - Height
    
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        let row = sections[indexPath.section].rows[indexPath.row]
        
        if rowHeightCalculator != nil {
            cellRegisterer?.register(cellType: row.cellType, forCellReuseIdentifier: row.reuseIdentifier)
        }
        
        return row.defaultHeight ?? row.estimatedHeight ?? rowHeightCalculator?.estimatedHeight(forRow: row, at: indexPath) ?? UITableViewAutomaticDimension
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let row = sections[indexPath.section].rows[indexPath.row]
        
        if rowHeightCalculator != nil {
            cellRegisterer?.register(cellType: row.cellType, forCellReuseIdentifier: row.reuseIdentifier)
        }

        let rowHeight = invoke(action: .height, cell: nil, indexPath: indexPath) as? CGFloat

        return rowHeight ?? row.defaultHeight ?? rowHeightCalculator?.height(forRow: row, at: indexPath) ?? UITableViewAutomaticDimension
    }
    
    // MARK: UITableViewDataSource - configuration
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].numberOfRows
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = sections[indexPath.section].rows[indexPath.row]
        
        cellRegisterer?.register(cellType: row.cellType, forCellReuseIdentifier: row.reuseIdentifier)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier, for: indexPath)
        
        if cell.frame.size.width != tableView.frame.size.width {
            cell.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: cell.frame.size.height)
            cell.layoutIfNeeded()
        }
        
        row.configure(cell)
        invoke(action: .configure, cell: cell, indexPath: indexPath)
        
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
        return section.headerHeight ?? section.headerView?.frame.size.height ?? UITableViewAutomaticDimension
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        let section = sections[section]
        return section.footerHeight ?? section.footerView?.frame.size.height ?? UITableViewAutomaticDimension
    }
    
    // MARK: UITableViewDelegate - actions
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if invoke(action: .click, cell: cell, indexPath: indexPath) != nil {
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            invoke(action: .select, cell: cell, indexPath: indexPath)
        }
    }
    
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        invoke(action: .deselect, cell: tableView.cellForRow(at: indexPath), indexPath: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        invoke(action: .willDisplay, cell: cell, indexPath: indexPath)
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
    
    // MARK: - Row editing
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return sections[indexPath.section].rows[indexPath.row].isEditingAllowed(forIndexPath: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return sections[indexPath.section].rows[indexPath.row].editingActions
    }
    
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            invoke(action: .clickDelete, cell: tableView.cellForRow(at: indexPath), indexPath: indexPath)
        }
    }
}

// MARK: - Sections manipulation
extension TableDirector {
    
    @discardableResult
    open func append(section: TableSection) -> Self {
        
        append(sections: [section])
        return self
    }
    
    @discardableResult
    open func append(sections: [TableSection]) -> Self {
        
        self.sections.append(contentsOf: sections)
        return self
    }
    
    @discardableResult
    open func append(rows: [Row]) -> Self {
        
        append(section: TableSection(rows: rows))
        return self
    }
    
    @discardableResult
    open func insert(section: TableSection, atIndex index: Int) -> Self {
        
        sections.insert(section, at: index)
        return self
    }
    
    @discardableResult
    open func delete(sectionAt index: Int) -> Self {
        
        sections.remove(at: index)
        return self
    }

    @discardableResult
    open func remove(sectionAt index: Int) -> Self {
        return delete(sectionAt: index)
    }
    
    @discardableResult
    open func clear() -> Self {
        
        rowHeightCalculator?.invalidate()
        sections.removeAll()
        
        return self
    }
    
    // MARK: - deprecated methods
    
    @available(*, deprecated, message: "Use 'delete(sectionAt:)' method instead")
    @discardableResult
    open func delete(index: Int) -> Self {
        
        sections.remove(at: index)
        return self
    }
}
