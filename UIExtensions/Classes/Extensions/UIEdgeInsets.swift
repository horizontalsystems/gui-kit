import UIKit

extension UIEdgeInsets {

    public var width: CGFloat {
        return self.left + self.right
    }

    public var height: CGFloat {
        return self.top + self.bottom
    }

    public func add(_ other: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.top + other.top, left: self.left + other.left, bottom: self.bottom + other.bottom, right: self.right + other.right)
    }

}
