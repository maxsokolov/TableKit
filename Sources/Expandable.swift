import UIKit

public protocol Expandable {

    associatedtype ViewModelType: ExpandableCellViewModel

    var viewModel: ViewModelType? { get }

    func configureAppearance(isCollapsed: Bool)

}

extension Expandable where Self: UITableViewCell & ConfigurableCell {

    public func initState() {
        guard let viewModel = viewModel else {
            return
        }

        changeState(isCollapsed: viewModel.isCollapsed)
    }

    private func changeState(isCollapsed: Bool) {
        // layout to get right frames, frame of bottom subview can be used to get expanded height
        layoutIfNeeded()

        // apply changes
        configureAppearance(isCollapsed: isCollapsed)
        layoutIfNeeded()
    }

    public func toggleState(animated: Bool = true,
                            animationDuration: TimeInterval = 0.3) {

        guard let tableView = tableView,
              let viewModel = viewModel else {
            return
        }

        let contentOffset = tableView.contentOffset

        if animated {
            UIView.animate(withDuration: animationDuration,
                           animations: { [weak self] in
                self?.applyChanges(isCollapsed: !viewModel.isCollapsed)
            }, completion: { _ in
                viewModel.isCollapsed.toggle()
            })
        } else {
            applyChanges(isCollapsed: !viewModel.isCollapsed)
            viewModel.isCollapsed.toggle()
        }

        tableView.beginUpdates()
        tableView.endUpdates()

        tableView.setContentOffset(contentOffset, animated: false)
    }

    private func applyChanges(isCollapsed: Bool) {
        changeState(isCollapsed: isCollapsed)

        if let indexPath = indexPath,
           let tableDirector = (tableView?.delegate as? TableDirector),
           let cellHeightCalculator = tableDirector.rowHeightCalculator as? ExpandableCellHeightCalculator {
            cellHeightCalculator.updateCached(height: height(layoutType: Self.layoutType), for: indexPath)
        }
    }

}
