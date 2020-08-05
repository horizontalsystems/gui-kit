import UIKit

class ChartEma {
    private let emaShort = ChartLine()
    private let emaLong = ChartLine()

    private let shortText = ChartText()
    private let longText = ChartText()

    private var configuration: ChartConfiguration?

    init(configuration: ChartConfiguration? = nil) {
        if let configuration = configuration {
            apply(configuration: configuration)
        }
    }

    @discardableResult func apply(configuration: ChartConfiguration) -> Self {
        self.configuration = configuration

        emaShort.strokeColor = configuration.emaShortColor
        emaShort.lineWidth = configuration.emaShortLineWidth
        emaShort.animationStyle = .strokeEnd
        emaShort.padding = configuration.curvePadding
        emaShort.animationDuration = configuration.animationDuration

        emaLong.strokeColor = configuration.emaLongColor
        emaLong.lineWidth = configuration.emaLongLineWidth
        emaLong.animationStyle = .strokeEnd
        emaLong.padding = configuration.curvePadding
        emaLong.animationDuration = configuration.animationDuration

        shortText.textColor = configuration.emaShortColor
        shortText.font = configuration.emaTextFont
        shortText.insets = configuration.emaShortInsets
        shortText.size = configuration.emaShortSize
        shortText.set(text: configuration.emaShortText)

        longText.textColor = configuration.emaLongColor
        longText.font = configuration.emaTextFont
        longText.insets = configuration.emaLongInsets
        longText.size = configuration.emaLongSize
        longText.set(text: configuration.emaLongText)

        return self
    }

    @discardableResult func add(to chart: Chart) -> Self {
        chart.add(emaShort)
        chart.add(emaLong)

        chart.add(shortText)
        chart.add(longText)

        return self
    }

    func set(short: [CGPoint]?, long: [CGPoint]?, animated: Bool) {
        emaShort.set(points: short ?? [], animated: animated)
        emaLong.set(points: long ?? [], animated: animated)
    }

    func set(hidden: Bool) {
        emaShort.layer.isHidden = hidden
        emaLong.layer.isHidden = hidden
        shortText.layer.isHidden = hidden
        longText.layer.isHidden = hidden
    }

    func set(selected: Bool) {
        // don't change colors
    }

}
