import UIKit

class ShapeHelper {

    static func linePath(points: [CGPoint]) -> CGPath {
        let newPath = UIBezierPath()

        guard !points.isEmpty else {
            return newPath.cgPath
        }

        newPath.move(to: points[0])
        for i in 1..<points.count {
            newPath.addLine(to: points[i])
        }

        return newPath.cgPath
    }

    static func convertRelative(point: CGPoint, size: CGSize, padding: UIEdgeInsets) -> CGPoint {
        let paddingSize = CGSize(width: padding.left + padding.right, height: padding.top + padding.bottom)

        return CGPoint(x: padding.left + (size.width - paddingSize.width) * point.x, y: padding.top + (size.height - paddingSize.height) * point.y)
    }

    static func closePoints(points: [CGPoint], size: CGSize) -> [CGPoint] {
        var arr = [CGPoint]()
        if let first = points.first {
            arr.append(CGPoint(x: first.x, y: size.height))
        }
        arr.append(contentsOf: points)
        if let last = points.last {
            arr.append(CGPoint(x: last.x, y: size.height))
        }
        return arr
    }

    private static func indexes(count: Int, elementCount: Int) -> [Int] {
        var arr = [Int]()
        for i in 0..<count {
            let index = i * elementCount / count + elementCount / (2 * count)
            arr.append(index - 1)
        }
        return arr
    }

    static func correctPoints(lastPoints: [CGPoint], newCount: Int) -> [CGPoint] {
        guard !lastPoints.isEmpty else {
            return lastPoints
        }
        var startPoints = lastPoints
        let diffCount = abs(lastPoints.count - newCount)
        let shift = min(diffCount, 2)
        let shift2 = min(shift, 1)
        let arr = indexes(count: diffCount, elementCount: lastPoints.count - shift)
        if lastPoints.count > newCount {
            for index in arr.reversed() {
                startPoints.remove(at: index + shift2)
            }
        } else if lastPoints.count < newCount {
            for index in arr.reversed() {
                startPoints.insert(startPoints[index + shift2], at: index + shift2)
            }
        }
        return startPoints
    }

    static func animation(keyPath: String, from: Any?, to: Any?, duration: CFTimeInterval, timingFunction: CAMediaTimingFunction?) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        animation.timingFunction = timingFunction
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards

        return animation
    }

}
