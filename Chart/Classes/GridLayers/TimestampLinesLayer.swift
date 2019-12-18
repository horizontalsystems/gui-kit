import UIKit

class TimestampLinesLayer: CAShapeLayer {

    func refresh(configuration: ChartConfiguration, insets: UIEdgeInsets, chartFrame: ChartFrame, timestamps: [TimeInterval]) {
        guard !bounds.isEmpty else {
            return
        }
        let edgeOffset: CGFloat = 0.5 / UIScreen.main.scale
        let width = floor(bounds.width) - (insets.left + insets.right)
        let height = floor(bounds.height) - (insets.top + insets.bottom)
        let deltaX = width / CGFloat(chartFrame.width)

        let verticalPath = UIBezierPath()

        for timestamp in timestamps {
            let pointOffsetX = floor(CGFloat(timestamp - chartFrame.left) * deltaX)
            if (abs(pointOffsetX) < configuration.gridNonVisibleLineDeltaX) || (abs(width - pointOffsetX) < configuration.gridNonVisibleLineDeltaX) {
                // don't show lines
                continue
            }

            verticalPath.move(to: CGPoint(x: insets.left + pointOffsetX + edgeOffset, y: insets.top))
            verticalPath.addLine(to: CGPoint(x: insets.left + pointOffsetX + edgeOffset, y: height))
        }

        verticalPath.close()

        strokeColor = configuration.gridColor.cgColor
        lineWidth = 1 / UIScreen.main.scale
        path = verticalPath.cgPath

        removeAllAnimations()
    }

}
