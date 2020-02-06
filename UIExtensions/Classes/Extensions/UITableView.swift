import UIKit

extension UITableView {

    public func registerCell(forNib nibClass: UITableViewCell.Type) {
        register(UINib(nibName: String(describing: nibClass), bundle: Bundle(for: nibClass)), forCellReuseIdentifier: String(describing: nibClass))
    }

    public func registerCell(forClass anyClass: UITableViewCell.Type) {
        register(anyClass, forCellReuseIdentifier: String(describing: anyClass))
    }

    public func registerHeaderFooter(forNib nibClass: UITableViewHeaderFooterView.Type) {
        register(UINib(nibName: String(describing: nibClass), bundle: Bundle(for: nibClass)), forHeaderFooterViewReuseIdentifier: String(describing: nibClass))
    }

    public func registerHeaderFooter(forClass anyClass: UITableViewHeaderFooterView.Type) {
        register(anyClass, forHeaderFooterViewReuseIdentifier: String(describing: anyClass))
    }

    public func deselectCell(withCoordinator coordinator: UIViewControllerTransitionCoordinator?, animated: Bool) {
        if let indexPath = indexPathForSelectedRow {
            if let coordinator = coordinator {
                coordinator.animate(alongsideTransition: { [weak self] context in
                    self?.deselectRow(at: indexPath, animated: animated)
                }, completion: { [weak self] context in
                    if context.isCancelled {
                        self?.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    }
                })
            } else {
                deselectRow(at: indexPath, animated: animated)
            }
        }
    }

}
