import UIKit
import TableKit

class MainController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableDirector = TableDirector(tableView: tableView)
        }
    }
    var tableDirector: TableDirector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TableKit"

        let clickAction = TableRowAction<ConfigurableTableViewCell>(.click) { [weak self] (options) in
            
            switch options.indexPath.row {
            case 0:
                self?.performSegue(withIdentifier: "autolayoutcells", sender: nil)
            case 1:
                self?.performSegue(withIdentifier: "nibcells", sender: nil)
            default:
                break
            }
        }
        
        let printClickAction = TableRowAction<ConfigurableTableViewCell>(.click) { (options) in
            
            print("click", options.indexPath)
        }

        let rows = [

            TableRow<ConfigurableTableViewCell>(item: "Autolayout cells", actions: [clickAction, printClickAction]),
            TableRow<ConfigurableTableViewCell>(item: "Nib cells", actions: [clickAction, printClickAction])
        ]

        // automatically creates a section, also could be used like tableDirector.append(rows: rows)
        tableDirector += rows
    }
}
