import UIKit

class ChartText: IChartObject {
    public var insets: UIEdgeInsets = .zero
    public var size: CGSize? = nil

    public var padding: UIEdgeInsets = .zero

    private let textLayer = CATextLayer()
    var layer: CALayer { textLayer }

    init() {
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = font
        textLayer.fontSize = font.pointSize
        textLayer.foregroundColor = textColor.cgColor
    }

    public var backgroundColor: UIColor? {
        didSet {
            textLayer.backgroundColor = backgroundColor?.cgColor
        }
    }

    public var textColor: UIColor = .black {
        didSet {
            textLayer.foregroundColor = textColor.cgColor
        }
    }

    public var font: UIFont = .systemFont(ofSize: 14) {
        didSet {
            textLayer.font = font
            textLayer.fontSize = font.pointSize
        }
    }

    public var textAlignment: CATextLayerAlignmentMode = .natural {
        didSet {
            textLayer.alignmentMode = textAlignment
        }
    }

    public func set(text: String?) {
        textLayer.string = text
    }

    func updateFrame(in bounds: CGRect, duration: CFTimeInterval?, timingFunction: CAMediaTimingFunction?) {
        layer.frame = LayerFrameHelper.frame(insets: insets, size: size, in: bounds)
    }

}
