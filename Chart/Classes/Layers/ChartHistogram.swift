import UIKit

class ChartHistogram: ChartPointsObject {
    private let wrapperLayer = CALayer()
    private let positiveBars = ChartBars()
    private let negativeBars = ChartBars()

    var barPosition: ChartBarPosition = .end

    override var layer: CALayer {
        wrapperLayer
    }

    public var backgroundColor: UIColor? {
        didSet {
            positiveBars.layer.backgroundColor = backgroundColor?.cgColor
            negativeBars.layer.backgroundColor = backgroundColor?.cgColor
        }
    }

    public var positiveStrokeColor: UIColor = .clear {
        didSet {
            positiveBars.strokeColor = positiveStrokeColor
        }
    }

    public var negativeStrokeColor: UIColor = .clear {
        didSet {
            negativeBars.strokeColor = negativeStrokeColor
        }
    }

    public var barWidth: CGFloat = 4 {
        didSet {
            positiveBars.layer.displayIfNeeded()
            negativeBars.layer.displayIfNeeded()
        }
    }

    public var positiveBarFillColor: UIColor? = nil {
        didSet {
            positiveBars.barFillColor = positiveBarFillColor
        }
    }

    public var negativeBarFillColor: UIColor? = nil {
        didSet {
            negativeBars.barFillColor = negativeBarFillColor
        }
    }

    override init() {
        super.init()

        [positiveBars, negativeBars].forEach {
            $0.layer.shouldRasterize = true
            $0.layer.rasterizationScale = UIScreen.main.scale

            $0.strokeColor = .clear
            $0.barFillColor = nil
            $0.barPosition = barPosition

            wrapperLayer.addSublayer($0.layer)
        }
        negativeBars.pathDirection = .top

        reversePoint = false
    }

    override func corrected(points: [CGPoint], newCount: Int) -> [CGPoint] {
        points
    }

    override func absolute(points: [CGPoint]) -> [CGPoint] {
        points
    }

    private func split(points: [CGPoint]) -> (positive: [CGPoint], negative: [CGPoint]) {
        var positive = [CGPoint]()
        var negative = [CGPoint]()

        for point in points {
            if point.y >= 0.5 {
                positive.append(CGPoint(x: point.x, y: (point.y - 0.5) * 2))
            } else {
                negative.append(CGPoint(x: point.x, y: point.y * 2))
            }
        }

        return (positive: positive, negative: negative)
    }



    override func update(start: Bool, old: [CGPoint], new: [CGPoint], duration: CFTimeInterval?, timingFunction: CAMediaTimingFunction?) {
        let oldPoints = split(points: old)
        let newPoints = split(points: new)

        // if nothing changes, but current timestamp. We must use morphing for histogram
        positiveBars.morphingAnimationDisabled = oldPoints.positive.count != newPoints.positive.count
        negativeBars.morphingAnimationDisabled = oldPoints.negative.count != newPoints.negative.count

        positiveBars.set(points: newPoints.positive, animated: duration != nil)
        negativeBars.set(points: newPoints.negative, animated: duration != nil)
    }

    override func updateFrame(in bounds: CGRect, duration: CFTimeInterval?, timingFunction: CAMediaTimingFunction?) {
        super.updateFrame(in: bounds, duration: duration, timingFunction: timingFunction)

        var frame = wrapperLayer.bounds
        frame.size.height = frame.height / 2
        positiveBars.updateFrame(in: frame, duration: duration, timingFunction: timingFunction)

        frame.origin.y = frame.height
        negativeBars.updateFrame(in: frame, duration: duration, timingFunction: timingFunction)
    }

}
