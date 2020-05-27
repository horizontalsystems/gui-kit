import UIKit

enum ChartBarPosition {
    case start, center, end
}

class ChartBars: ChartPointsObject {
    private let minimumGap: CGFloat = 2

    private let barsLayer = CAShapeLayer()
    private let maskLayer = CALayer()

    var barPosition: ChartBarPosition = .end
    var morphingAnimationDisabled = false

    override var layer: CALayer {
        barsLayer
    }

    public var backgroundColor: UIColor? {
        didSet {
            barsLayer.backgroundColor = backgroundColor?.cgColor
        }
    }

    public var strokeColor: UIColor = .clear {
        didSet {
            barsLayer.strokeColor = strokeColor.cgColor
        }
    }

    public var barWidth: CGFloat = 4 {
        didSet {
            barsLayer.displayIfNeeded()
        }
    }

    public var barFillColor: UIColor? = nil {
        didSet {
            barsLayer.fillColor = barFillColor?.cgColor
        }
    }

    override init() {
        super.init()

        barsLayer.shouldRasterize = true
        barsLayer.rasterizationScale = UIScreen.main.scale
        barsLayer.mask = maskLayer
        barsLayer.fillColor = nil

        maskLayer.anchorPoint = .zero
        maskLayer.backgroundColor = UIColor.black.cgColor
    }

    override func appearingAnimation(new: [CGPoint], duration: CFTimeInterval, timingFunction: CAMediaTimingFunction?) -> CAAnimation? {
        switch animationStyle {
        case .verticalGrowing:
            return super.appearingAnimation(new: new, duration: duration, timingFunction: timingFunction)
        case .strokeEnd:
            maskLayer.bounds = barsLayer.bounds

            let startBounds = CGRect(x: 0, y: 0, width: 0, height: barsLayer.bounds.height)
            let boundsAnimation = ShapeHelper.animation(keyPath: "bounds", from: startBounds, to: barsLayer.bounds, duration: duration, timingFunction: timingFunction)
            maskLayer.add(boundsAnimation, forKey: strokeAnimationKey)
            return CABasicAnimation(keyPath: animationKey)
        }
    }

    override public func set(points: [CGPoint], animated: Bool = false) {
        super.set(points: points, animated: animated)
    }

    override func path(points: [CGPoint]) -> CGPath {
        let barsPath = UIBezierPath()

        var lastX: CGFloat = -CGFloat.greatestFiniteMagnitude
        points.forEach { point in
            var startX: CGFloat
            switch barPosition {
            case .start:
                startX = point.x
            case .center:
                startX = point.x - (barWidth / 2)
            case .end:
                startX = point.x - barWidth
            }
            if lastX > startX {     // between bars need minimumGap pixels
                startX = lastX
            }

            let maxAllowedWidth = min(barsLayer.bounds.width - startX, barWidth)
            lastX = startX + maxAllowedWidth + minimumGap

            barsPath.move(to: CGPoint(x: startX, y: zeroY))
            barsPath.addLine(to: CGPoint(x: startX, y: point.y))
            barsPath.addLine(to: CGPoint(x: startX + maxAllowedWidth, y: point.y))
            barsPath.addLine(to: CGPoint(x: startX + maxAllowedWidth, y: zeroY))
            barsPath.close()
        }
        return barsPath.cgPath
    }

    override func corrected(points: [CGPoint], newCount: Int) -> [CGPoint] {
        points
    }

    override func transformAnimation(oldPath: CGPath, new: [CGPoint], duration: CFTimeInterval, timingFunction: CAMediaTimingFunction?) -> CAAnimation {
        guard points.count != new.count || morphingAnimationDisabled else {
            return super.transformAnimation(oldPath: oldPath, new: new, duration: duration, timingFunction: timingFunction)
        }
        // when count is different we animated hiding old bars and show new
        let downOldPath = path(points: absolute(points: self.points).map { CGPoint(x: $0.x, y: zeroY) })

        let downNewPath = path(points: new.map { CGPoint(x: $0.x, y: zeroY) })
        let newPath = path(points: new)

        let halfDuration = duration / 2

        let downAnimation = ShapeHelper.animation(keyPath: "path", from: oldPath,
                to: downOldPath,
                duration: duration,
                timingFunction: timingFunction)
        downAnimation.duration = halfDuration

        let upAnimation = ShapeHelper.animation(keyPath: "path", from: downNewPath,
                to: newPath,
                duration: duration,
                timingFunction: timingFunction)
        upAnimation.duration = halfDuration
        upAnimation.beginTime = halfDuration

        let group = CAAnimationGroup()

        group.duration = duration
        group.animations = [downAnimation, upAnimation]

        return group
    }

    override func updateFrame(in bounds: CGRect, duration: CFTimeInterval?, timingFunction: CAMediaTimingFunction?) {
        super.updateFrame(in: bounds, duration: duration, timingFunction: timingFunction)

        maskLayer.bounds = barsLayer.bounds
    }

}
