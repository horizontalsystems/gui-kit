import UIKit

protocol IChartObject {
    var layer: CALayer { get }
    func updateFrame(in bounds: CGRect, duration: CFTimeInterval?, timingFunction: CAMediaTimingFunction?)
}

enum ChartStartAnimationStyle: Int {
    case verticalGrowing
    case strokeEnd
}

enum ChartPathDirection {
    case top, bottom
}

class ChartPointsObject: NSObject, IChartObject {
    let strokeAnimationKey = "strokeEndAnimation"
    let animationKey = "lineAnimation"

    var reversePoint = true

    public var pathDirection: ChartPathDirection = .bottom
    public var animationDuration: TimeInterval = 0.3
    public var animationStyle: ChartStartAnimationStyle = .verticalGrowing
    public var insets: UIEdgeInsets = .zero
    public var size: CGSize? = nil

    public var padding: UIEdgeInsets = .zero

    var layer: CALayer {                                        // layer which will be added to chart
        fatalError("Must be implemented by Concrete subclass.")
    }

    var zeroY: CGFloat {
        pathDirection == .bottom ? layer.bounds.height : 0
    }

    var animationLayer: CALayer {                               // layer which will be used to animation
        layer
    }

    var points = [CGPoint]()

    func absolute(points: [CGPoint]) -> [CGPoint] {
        points.map { ShapeHelper.convertRelative(point: $0, size: layer.bounds.size, padding: padding) }
    }

    // point correction when old point count not equal to new count
    func corrected(points: [CGPoint], newCount: Int) -> [CGPoint] {
        ShapeHelper.correctPoints(lastPoints: points, newCount: newCount)
    }

    func diffData(for points: [CGPoint]) -> (start: Bool, old: [CGPoint], new: [CGPoint]) {
        let start = self.points.isEmpty

        let old = absolute(points: corrected(points: self.points, newCount: points.count))
        let new = absolute(points: points)

        return (start: start, old: old, new: new)
    }

    public func set(points: [CGPoint], animated: Bool = false) {
        // we must revert y-coordinate before set
        let reverted = reversePoint ? points.map { CGPoint(x: $0.x, y: 1 - $0.y) } : points

        let data = diffData(for: reverted)

        update(start: data.start, old: data.old, new: data.new, duration: animated ? animationDuration : nil, timingFunction: CAMediaTimingFunction(name: .easeInEaseOut))
        self.points = reverted
    }

    func path(points: [CGPoint]) -> CGPath {
        ShapeHelper.linePath(points: points)
    }

    func update(start: Bool = false, old: [CGPoint], new: [CGPoint], duration: CFTimeInterval?, timingFunction: CAMediaTimingFunction?) {
        guard let animationLayer = animationLayer as? CAShapeLayer else {
            return
        }
        update(layer: animationLayer, start: start, old: old, new: new, duration: duration, timingFunction: CAMediaTimingFunction(name: .easeInEaseOut))
    }

    func update(layer: CAShapeLayer, start: Bool = false, old: [CGPoint], new: [CGPoint], duration: CFTimeInterval?, timingFunction: CAMediaTimingFunction?) {
        layer.path = path(points: new)

        guard let duration = duration else {
            return
        }

        let animation: CAAnimation?
        if start {     // if its first appearing animation, use animation style
            animation = appearingAnimation(new: new, duration: duration, timingFunction: timingFunction)
        } else {
            animation = transformAnimation(oldPath: path(points: old), new: new, duration: duration, timingFunction: timingFunction)
        }

        if let animation = animation {
            layer.add(animation, forKey: animationKey)
        }
    }

    func appearingAnimation(new: [CGPoint], duration: CFTimeInterval, timingFunction: CAMediaTimingFunction?) -> CAAnimation? {
        switch animationStyle {
        case .strokeEnd:
            return ShapeHelper.animation(keyPath: "strokeEnd", from: 0, to: 1, duration: duration, timingFunction: timingFunction)
        case .verticalGrowing:
            let newPath = path(points: new)
            let oldPath = path(points: new.map { CGPoint(x: $0.x, y: zeroY) })

            return ShapeHelper.animation(keyPath: "path", from: oldPath,
                    to: newPath,
                    duration: duration,
                    timingFunction: timingFunction)
        }
    }

    func transformAnimation(oldPath: CGPath, new: [CGPoint], duration: CFTimeInterval, timingFunction: CAMediaTimingFunction?) -> CAAnimation {
        let newPath = path(points: new)

        return ShapeHelper.animation(keyPath: "path", from: oldPath,
                to: newPath,
                duration: duration,
                timingFunction: timingFunction)
    }

    func updateFrame(in bounds: CGRect, duration: CFTimeInterval?, timingFunction: CAMediaTimingFunction?) {
        let old = absolute(points: points)
        layer.frame = LayerFrameHelper.frame(insets: insets, size: size, in: bounds)
        let new = absolute(points: points)

        update(old: old, new: new,
                duration: duration, timingFunction: timingFunction)
    }

}
