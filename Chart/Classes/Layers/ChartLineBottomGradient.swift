import UIKit

class ChartLineBottomGradient: ChartPointsObject {
    private let gradientLayer = CAGradientLayer()
    private let maskLayer = CAShapeLayer()

    override var layer: CALayer {
        gradientLayer
    }

    override var animationLayer: CALayer {
        maskLayer
    }

    override func absolute(points: [CGPoint]) -> [CGPoint] {
        let absolutePoints = points.map { ShapeHelper.convertRelative(point: $0, size: gradientLayer.bounds.size, padding: padding) }
        return ShapeHelper.closePoints(points: absolutePoints, size: gradientLayer.bounds.size)
    }

    public var backgroundColor: UIColor? {
        didSet {
            gradientLayer.backgroundColor = backgroundColor?.cgColor
        }
    }

    public var gradientColors: [UIColor] = [.clear] {
        didSet {
            gradientLayer.colors = gradientColors.map { $0.cgColor }
        }
    }

    public var gradientLocations: [NSNumber]? = nil {
        didSet {
            gradientLayer.locations = gradientLocations
        }
    }

    override init() {
        super.init()

        gradientLayer.shouldRasterize = true
        gradientLayer.rasterizationScale = UIScreen.main.scale
        gradientLayer.anchorPoint = .zero

        maskLayer.shouldRasterize = true
        maskLayer.rasterizationScale = UIScreen.main.scale

        gradientLayer.backgroundColor = UIColor.clear.cgColor
        gradientLayer.mask = maskLayer
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
    }

    override func appearingAnimation(new: [CGPoint], duration: CFTimeInterval, timingFunction: CAMediaTimingFunction?) -> CAAnimation? {
        switch animationStyle {
        case .verticalGrowing:
            return super.appearingAnimation(new: new, duration: duration, timingFunction: timingFunction)
        case .strokeEnd:
            let startBounds = CGRect(x: 0, y: 0, width: 0, height: gradientLayer.bounds.height)
            let boundsAnimation = ShapeHelper.animation(keyPath: "bounds", from: startBounds, to: gradientLayer.bounds, duration: duration, timingFunction: timingFunction)
            gradientLayer.add(boundsAnimation, forKey: strokeAnimationKey)
            return CABasicAnimation(keyPath: animationKey)
        }
    }

}
