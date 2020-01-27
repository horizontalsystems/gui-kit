import UIKit

extension UIView {

    public var width: CGFloat {
        frame.size.width
    }

    public var height: CGFloat {
        frame.size.height
    }

    public var x: CGFloat {
        frame.origin.x
    }

    public var y: CGFloat {
        frame.origin.y
    }

    public var bottom: CGFloat {
        frame.origin.y + frame.size.height
    }

    public var size: CGSize {
        frame.size
    }

    @IBInspectable
    public var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue != 0
        }
    }

    @IBInspectable
    public var borderWidth: CGFloat {
        get {
            layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

}
