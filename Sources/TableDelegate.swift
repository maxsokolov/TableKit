import UIKit

class TableDelegate: NSObject, UITableViewDelegate {
    
    private weak var tableDirector: TableDirectorV2?
    
    init(tableDirector: TableDirectorV2) {
        
        self.tableDirector = tableDirector
        super.init()
        self.tableDirector?.tableView?.delegate = self
    }
    
    // MARK: - Cell height -
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - Actions -
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let cell = tableView.cellForRow(at: indexPath)
        if tableDirector?.invoke(action: .click, cell: cell, indexPath: indexPath) != nil {
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            _ = tableDirector?.invoke(action: .select, cell: cell, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        _ = tableDirector?.invoke(action: .deselect, cell: tableView.cellForRow(at: indexPath), indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        _ = tableDirector?.invoke(action: .willDisplay, cell: cell, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return tableDirector?.invoke(action: .shouldHighlight, cell: tableView.cellForRow(at: indexPath), indexPath: indexPath) as? Bool ?? true
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if tableDirector?.hasAction(.willSelect, atIndexPath: indexPath) == true {
            return tableDirector?.invoke(action: .willSelect, cell: tableView.cellForRow(at: indexPath), indexPath: indexPath) as? IndexPath
        }
        return indexPath
    }
    
    // MARK: - Sections accessories -
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableDirector?.sections[section].headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableDirector?.sections[section].footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let section = tableDirector?.sections[section]
        return section?.headerHeight ?? section?.headerView?.frame.size.height ?? UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        let section = tableDirector?.sections[section]
        return section?.footerHeight ?? section?.footerView?.frame.size.height ?? UITableViewAutomaticDimension
    }
}
