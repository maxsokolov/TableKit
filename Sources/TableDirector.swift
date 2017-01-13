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

public struct TableOptions: OptionSet {

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automaticCellRegistration = TableOptions(rawValue: 1 << 0)
    public static let prototypeCellLayout       = TableOptions(rawValue: 1 << 1)
    public static let estimatedHeightEnabled    = TableOptions(rawValue: 1 << 2)

    public static let defaultOptions: TableOptions = [.automaticCellRegistration, .estimatedHeightEnabled]
}

open class TableDirector {
    
    open private(set) weak var tableView: UITableView?
    open private(set) var sections = [TableSection]()
    
    private var dataSource: TableDataSource?
    private var delegate: TableDelegate?
    var cellRegisterer: TableCellRegisterer?
    public private(set) var rowHeightCalculator: RowHeightCalculator?
    
    open var isEmpty: Bool {
        return sections.isEmpty
    }
    
    public init(tableView: UITableView, scrollDelegate: UIScrollViewDelegate? = nil, options: TableOptions = .defaultOptions) { // cellHeightCalculator: RowHeightCalculator?
        
        if options.contains(.automaticCellRegistration) {
            
            cellRegisterer = TableCellRegisterer(
                tableView: tableView
            )
        }
        
        self.tableView = tableView
        self.dataSource = TableDataSource(
            tableDirector: self
        )
        self.delegate = TableDelegate(
            tableDirector: self,
            scrollDelegate: scrollDelegate,
            rowHeightCalculator: TablePrototypeCellHeightCalculator(tableView: tableView)
        )
        
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(didReceiveAction), name: NSNotification.Name(rawValue: TableKitNotifications.CellAction), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open func reload() {
        tableView?.reloadData()
    }
    
    // MARK: -
    
    @objc func didReceiveAction(_ notification: Notification) {
        
        guard let action = notification.object as? TableCellAction, let indexPath = tableView?.indexPath(for: action.cell) else { return }
        invoke(action: .custom(action.key), cell: action.cell, indexPath: indexPath, userInfo: notification.userInfo)
    }
    
    @discardableResult
    func invoke(action: TableRowActionType, cell: UITableViewCell?, indexPath: IndexPath, userInfo: [AnyHashable: Any]? = nil) -> Any? {
        return sections[indexPath.section].rows[indexPath.row].invoke(action: action, cell: cell, path: indexPath, userInfo: userInfo)
    }
    
    func hasAction(_ action: TableRowActionType, atIndexPath indexPath: IndexPath) -> Bool {
        return sections[indexPath.section].rows[indexPath.row].has(action: action)
    }
    
    // MARK: - Sections manipulation
    
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
}
