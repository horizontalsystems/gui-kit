import UIKit

class LimitTextLayer: CATextLayer {

    func refresh(configuration: ChartConfiguration, pointConverter: IPointConverter, insets: UIEdgeInsets, chartFrame: ChartFrame) {
        guard !bounds.isEmpty else {
            return
        }
        self.sublayers?.removeAll()

        let frameBounds = bounds.inset(by: insets)
        let maxPointOffsetY = pointConverter.convert(timestamp: 0, value: chartFrame.maxValue,
                viewBounds: frameBounds, chartFrame: chartFrame, retinaShift: false).y - configuration.limitTextFont.lineHeight - configuration.limitTextInMargin
        let minPointOffsetY = pointConverter.convert(timestamp: 0, value: chartFrame.minValue,
                viewBounds: frameBounds, chartFrame: chartFrame, retinaShift: false).y + configuration.limitTextInMargin

        let formatter = configuration.limitTextFormatter ?? ValueScaleHelper.formatter
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = max(0, chartFrame.scale)

        let insetsWidth = insets.left + insets.right

        let maxTextLayer = CATextLayer()
        maxTextLayer.contentsScale = UIScreen.main.scale
        maxTextLayer.frame = CGRect(x: insets.left + configuration.limitTextLeftMargin, y: maxPointOffsetY, width: bounds.width - configuration.limitTextLeftMargin - insetsWidth, height: configuration.limitTextFont.lineHeight)
        maxTextLayer.foregroundColor = configuration.limitTextColor.cgColor
        maxTextLayer.font = CTFontCreateWithFontDescriptor(configuration.limitTextFont.fontDescriptor, configuration.limitTextFont.pointSize, nil)
        maxTextLayer.fontSize = configuration.limitTextFont.pointSize

        maxTextLayer.string = formatter.string(from: (chartFrame.maxValue) as NSNumber)
        maxTextLayer.removeAllAnimations()

        addSublayer(maxTextLayer)

        let minTextLayer = CATextLayer()
        minTextLayer.contentsScale = UIScreen.main.scale
        minTextLayer.frame = CGRect(x: insets.left + configuration.limitTextLeftMargin, y: minPointOffsetY, width: bounds.width - configuration.limitTextLeftMargin - insetsWidth, height: configuration.limitTextFont.lineHeight)
        minTextLayer.foregroundColor = configuration.limitTextColor.cgColor
        minTextLayer.font = CTFontCreateWithFontDescriptor(configuration.limitTextFont.fontDescriptor, configuration.limitTextFont.pointSize, nil)
        minTextLayer.fontSize = configuration.limitTextFont.pointSize
        minTextLayer.string = formatter.string(from: (chartFrame.minValue) as NSNumber)
        minTextLayer.removeAllAnimations()

        addSublayer(minTextLayer)
    }

}
