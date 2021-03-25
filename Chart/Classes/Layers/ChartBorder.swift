import UIKit

class ChartBorder: IChartObject {
    private let borderLayer = CAShapeLayer()

    public var insets: UIEdgeInsets = .zero
    public var size: CGSize? = nil

    public var padding: UIEdgeInsets = .zero

    var layer: CALayer {
        borderLayer
    }

    public var backgroundColor: UIColor? {
        didSet {
            borderLayer.backgroundColor = backgroundColor?.cgColor
        }
    }

    public var strokeColor: UIColor = .clear {
        didSet {
            borderLayer.strokeColor = strokeColor.cgColor
        }
    }

    public var lineWidth: CGFloat = 1 {
        didSet {
            borderLayer.lineWidth = lineWidth
        }
    }

    public var lineDashPattern: [NSNumber]? = nil {
        didSet {
            borderLayer.lineDashPattern = lineDashPattern
        }
    }

    init() {
        borderLayer.shouldRasterize = true
        borderLayer.rasterizationScale = UIScreen.main.scale

        borderLayer.backgroundColor = UIColor.clear.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor

        borderLayer.lineWidth = lineWidth
    }

    func path() -> CGPath {
        let offset: CGFloat = LayerFrameHelper.offset(lineWidth: lineWidth)
        let size = CGSize(width: borderLayer.bounds.width - 2 * offset, height: borderLayer.bounds.height - 1 / UIScreen.main.scale)
        return UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: offset, y: offset), size: size), cornerRadius: 0).cgPath
    }

    func updateFrame(in bounds: CGRect, duration: CFTimeInterval?, timingFunction: CAMediaTimingFunction?) {
        borderLayer.frame = LayerFrameHelper.frame(insets: insets, size: size, in: bounds)

        borderLayer.path = path()
    }

}
