import UIKit

class TimestampTextLayer: CATextLayer {

    func refresh(configuration: ChartConfiguration, gridIntervalType: GridIntervalType, insets: UIEdgeInsets, chartFrame: ChartFrame, timestamps: [TimeInterval]) {
        guard !bounds.isEmpty else {
            return
        }

        self.sublayers?.removeAll()

        let dateFormatter = configuration.dateFormatter ?? DateFormatter()

        let width = bounds.width - (insets.left + insets.right)
        let delta = width / CGFloat(chartFrame.width)

        for timestamp in timestamps {
            let text = TimestampFormatter.text(timestamp: timestamp, gridIntervalType: gridIntervalType, dateFormatter: dateFormatter)
            let textSize = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: configuration.gridTextFont])

            var pointOffsetX = CGFloat(timestamp - chartFrame.left) * delta
            if pointOffsetX < configuration.gridNonVisibleLineDeltaX {
                pointOffsetX = 0
            } else if abs(pointOffsetX + textSize.width + configuration.gridNonVisibleLineDeltaX) > width {
                pointOffsetX = width - textSize.width
            }

            let textLayer = CATextLayer()
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.frame = CGRect(x: insets.left + pointOffsetX, y: configuration.gridTextMargin, width: textSize.width, height: textSize.height)
            textLayer.foregroundColor = configuration.gridTextColor.cgColor
            textLayer.font = CTFontCreateWithFontDescriptor(configuration.gridTextFont.fontDescriptor, configuration.gridTextFont.pointSize, nil)
            textLayer.fontSize = configuration.gridTextFont.pointSize
            textLayer.string = text

            textLayer.removeAllAnimations()

            addSublayer(textLayer)
        }
        removeAllAnimations()
    }

}
