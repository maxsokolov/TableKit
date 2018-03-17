import UIKit
import TableKit

class ConfigurableTableViewCell: UITableViewCell, ConfigurableCell {
    
    func configure(with text: String) {

        accessoryType = .disclosureIndicator
        textLabel?.text = text
    }
}
