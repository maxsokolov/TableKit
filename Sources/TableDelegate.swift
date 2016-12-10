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
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
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
