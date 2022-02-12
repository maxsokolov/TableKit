import UIKit

public final class ExpandableCellHeightCalculator: RowHeightCalculator {

    private weak var tableView: UITableView?

    private var prototypes = [String: UITableViewCell]()

    private var cachedHeights = [IndexPath: CGFloat]()

    public init(tableView: UITableView?) {
        self.tableView = tableView
    }

    public func updateCached(height: CGFloat, for indexPath: IndexPath) {
        cachedHeights[indexPath] = height
    }

    public func height(forRow row: Row, at indexPath: IndexPath) -> CGFloat {

        guard let tableView = tableView else {
            return 0
        }

        if let height = cachedHeights[indexPath] {
            return height
        }

        var prototypeCell = prototypes[row.reuseIdentifier]
        if prototypeCell == nil {
            prototypeCell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier)
            prototypes[row.reuseIdentifier] = prototypeCell
        }

        guard let cell = prototypeCell else {
            return 0
        }

        row.configure(cell)
        cell.layoutIfNeeded()

        let height = cell.height(layoutType: row.layoutType)
        cachedHeights[indexPath] = height
        return height
    }

    public func estimatedHeight(forRow row: Row, at indexPath: IndexPath) -> CGFloat {
        return height(forRow: row, at: indexPath)
    }

    public func invalidate() {
        cachedHeights.removeAll()
    }

}
