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

    public func set(hidden: Bool, animated: Bool = false, duration: TimeInterval = 0.3, completion: ((Bool) -> ())? = nil) {
        if isHidden == hidden {
            return
        }
        if animated {
            if !hidden {
                alpha = 0
                isHidden = false
            }
            UIView.animate(withDuration: duration, animations: {
                self.alpha = hidden ? 0 : 1
            }, completion: { success in
                self.alpha = 1
                self.isHidden = hidden
                completion?(success)
            })
        } else {
            isHidden = hidden
            completion?(true)
        }
    }

    public func shakeView(_ block: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(block)

        let animation = CAKeyframeAnimation(keyPath: "transform")
        let fromAnimation = NSValue(caTransform3D: CATransform3DMakeTranslation(-5, 0, 0))
        let toAnimation = NSValue(caTransform3D: CATransform3DMakeTranslation(5, 0, 0))

        animation.values = [fromAnimation, toAnimation]
        animation.autoreverses = true
        animation.repeatCount = 2
        animation.duration = 0.07
        layer.add(animation, forKey: "shakeAnimation")

        CATransaction.commit()
    }
    
    // drawing on context methods
    public func createRoundedRectPath(for rect: CGRect, radius: CGFloat) -> CGMutablePath {
        let path = CGMutablePath()

        let midTopPoint = CGPoint(x: rect.midX, y: rect.minY)
        path.move(to: midTopPoint)

        let topRightPoint = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRightPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeftPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let topLeftPoint = CGPoint(x: rect.minX, y: rect.minY)

        path.addArc(tangent1End: topRightPoint, tangent2End: bottomRightPoint, radius: radius)
        path.addArc(tangent1End: bottomRightPoint, tangent2End: bottomLeftPoint, radius: radius)
        path.addArc(tangent1End: bottomLeftPoint, tangent2End: topLeftPoint, radius: radius)
        path.addArc(tangent1End: topLeftPoint, tangent2End: topRightPoint, radius: radius)

        path.closeSubpath()

        return path
    }

    public func drawGradient(context: CGContext, rect: CGRect, colors: [CGColor], locations: [CGFloat]) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors: CFArray = colors as CFArray
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations) else {
            return
        }
        let startPoint = CGPoint(x: rect.midX, y: rect.minY)
        let endPoint = CGPoint(x: rect.midX, y: rect.maxY)

        context.saveGState()
        context.addRect(rect)
        context.clip()
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        context.restoreGState()
    }

}
