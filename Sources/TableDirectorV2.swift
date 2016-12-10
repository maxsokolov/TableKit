import UIKit

open class TableDirectorV2 {
    
    open private(set) weak var tableView: UITableView?
    open private(set) var sections = [TableSection]()
    
    private var dataSource: TableDataSource?
    private var delegate: TableDelegate?
    
    init(tableView: UITableView) {
        
        self.tableView = tableView
        self.dataSource = TableDataSource(tableDirector: self)
        self.delegate = TableDelegate(tableDirector: self)
    }
    
    // MARK: -
    
    @discardableResult
    func invoke(action: TableRowActionType, cell: UITableViewCell?, indexPath: IndexPath, userInfo: [AnyHashable: Any]? = nil) -> Any? {
        return sections[indexPath.section].rows[indexPath.row].invoke(action: action, cell: cell, path: indexPath, userInfo: userInfo)
    }
    
    func hasAction(_ action: TableRowActionType, atIndexPath indexPath: IndexPath) -> Bool {
        return sections[indexPath.section].rows[indexPath.row].has(action: action)
    }
    
    // MARK: -
    
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
        
        //rowHeightCalculator?.invalidate()
        sections.removeAll()
        
        return self
    }
}
