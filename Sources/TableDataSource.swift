import UIKit

class TableDataSource: NSObject, UITableViewDataSource {
    
    private weak var tableDirector: TableDirectorV2?
    
    init(tableDirector: TableDirectorV2) {
        
        self.tableDirector = tableDirector
        super.init()
        self.tableDirector?.tableView?.dataSource = self
    }
    
    // MARK: -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableDirector?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDirector?.sections[section].rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = tableDirector?.sections[indexPath.section].rows[indexPath.row] else { return UITableViewCell() }
        
        //cellRegisterer?.register(cellType: row.cellType, forCellReuseIdentifier: row.reuseIdentifier)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier, for: indexPath)
        
        if cell.frame.size.width != tableView.frame.size.width {
            cell.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: cell.frame.size.height)
            cell.layoutIfNeeded()
        }
        
        row.configure(cell)
        
        _ = tableDirector?.invoke(action: .configure, cell: cell, indexPath: indexPath)
        
        return UITableViewCell()
    }
    
    // MARK: - Sections accessories -
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableDirector?.sections[section].headerTitle
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return tableDirector?.sections[section].footerTitle
    }
    
    // MARK: - Rows editing -
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return tableDirector?.sections[indexPath.section].rows[indexPath.row].isEditingAllowed(forIndexPath: indexPath) ?? true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return tableDirector?.sections[indexPath.section].rows[indexPath.row].editingActions
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            _ = tableDirector?.invoke(action: .clickDelete, cell: tableView.cellForRow(at: indexPath), indexPath: indexPath)
        }
    }
}
