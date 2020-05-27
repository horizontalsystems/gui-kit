import UIKit

class ChartLine: ChartPointsObject {
    private let lineLayer = CAShapeLayer()

    override var layer: CALayer {
        lineLayer
    }

    public var backgroundColor: UIColor? {
        didSet {
            lineLayer.backgroundColor = backgroundColor?.cgColor
        }
    }

    public var strokeColor: UIColor = .clear {
        didSet {
            lineLayer.strokeColor = strokeColor.cgColor
        }
    }

    public var lineWidth: CGFloat = 1 {
        didSet {
            lineLayer.lineWidth = lineWidth
        }
    }

    override init() {
        super.init()

        lineLayer.shouldRasterize = true
        lineLayer.rasterizationScale = UIScreen.main.scale
        lineLayer.backgroundColor = UIColor.clear.cgColor

        lineLayer.fillColor = nil
    }

}
