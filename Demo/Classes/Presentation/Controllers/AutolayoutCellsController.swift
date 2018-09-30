import UIKit
import TableKit

class AutolayoutCellsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableDirector = TableDirector(tableView: tableView, shouldUsePrototypeCellHeightCalculation: true)
        }
    }
    var tableDirector: TableDirector!
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Autolayout cells"
        
        let header = AutolayoutSectionHeaderView.loadFromNib()
        let section = TableSection(headerView: header, footerView: nil)
        section.headerHeight = getViewHeight(view: header, width: UIScreen.main.bounds.width)
        
        var rows = 0
        while rows <= 20 {
            rows += 1
            
            let row = TableRow<AutolayoutTableViewCell>(item: randomString(length: randomInt(min: 20, max: 100)))
            section += row
        }
        
        tableDirector += section
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .done, target: self, action: #selector(clear))
    }
    
    @objc
    func clear() {
        
        tableDirector.clear()
        tableDirector.reload()
    }
    
    func getViewHeight(view: UIView, width: CGFloat) -> CGFloat {
        
        view.frame = CGRect(x: 0, y: 0, width: width, height: view.frame.size.height)
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        return view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    }
}
