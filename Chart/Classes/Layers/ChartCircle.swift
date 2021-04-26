import UIKit

class ChartCircle: ChartPointsObject {
    private let circleLayer = CAShapeLayer()

    override var layer: CALayer {
        circleLayer
    }

    public var backgroundColor: UIColor? {
        didSet {
            circleLayer.fillColor = backgroundColor?.cgColor
        }
    }

    public var strokeColor: UIColor? = .clear {
        didSet {
            circleLayer.strokeColor = strokeColor?.cgColor
        }
    }

    public var radius: CGFloat = 3

    override init() {
        super.init()

        circleLayer.shouldRasterize = true
        circleLayer.rasterizationScale = UIScreen.main.scale

        circleLayer.backgroundColor = UIColor.clear.cgColor

        circleLayer.lineWidth = 1 / UIScreen.main.scale
    }

    override func path(points: [CGPoint]) -> CGPath {
        let path = UIBezierPath()

        guard !points.isEmpty else {
            return path.cgPath
        }

        for point in points {
            let correctedPoint = ShapeHelper.convertRelative(point: point, size: size ?? .zero, padding: insets)
            path.addArc(withCenter: point, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        }

        return path.cgPath
    }

    override func updateFrame(in bounds: CGRect, duration: CFTimeInterval?, timingFunction: CAMediaTimingFunction?) {
        super.updateFrame(in: bounds, duration: duration, timingFunction: timingFunction)
    }
}
