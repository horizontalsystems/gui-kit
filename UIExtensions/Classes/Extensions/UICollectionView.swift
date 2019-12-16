import UIKit

public enum FlowSupplementaryKind {
    case header, footer
}

extension UICollectionView {

    public func registerCell(forNib nibClass: UICollectionViewCell.Type) {
        register(UINib(nibName: String(describing: nibClass), bundle: Bundle(for: nibClass)), forCellWithReuseIdentifier: String(describing: nibClass))
    }

    public func registerCell(forClass anyClass: UICollectionViewCell.Type) {
        register(anyClass, forCellWithReuseIdentifier: String(describing: anyClass))
    }

    public func registerView(forNib nibClass: UICollectionReusableView.Type, flowSupplementaryKind: FlowSupplementaryKind? = nil) {
        guard let kind = flowSupplementaryKind else {
            register(UINib(nibName: String(describing: nibClass), bundle: Bundle(for: nibClass)), forSupplementaryViewOfKind: String(describing: nibClass), withReuseIdentifier: String(describing: nibClass))
            return
        }
        switch kind {
        case .header: register(UINib(nibName: String(describing: nibClass), bundle: Bundle(for: nibClass)), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: nibClass))
        case .footer: register(UINib(nibName: String(describing: nibClass), bundle: Bundle(for: nibClass)), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: nibClass))
        }
    }

    public func registerView(forClass anyClass: UICollectionReusableView.Type, flowSupplementaryKind: FlowSupplementaryKind? = nil) {
        guard let kind = flowSupplementaryKind else {
            register(anyClass, forSupplementaryViewOfKind: String(describing: anyClass), withReuseIdentifier: String(describing: anyClass))
            return
        }
        switch kind {
        case .header: register(anyClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: anyClass))
        case .footer: register(anyClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: anyClass))
        }
    }

}
