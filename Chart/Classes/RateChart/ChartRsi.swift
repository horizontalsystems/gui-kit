import UIKit
import UIKit

class ChartRsi {
    private let rsi = ChartLine()
    private let rsiLimitLines = ChartGridLines()
    private let rsiTopValue = ChartText()
    private let rsiBottomValue = ChartText()

    private var configuration: ChartConfiguration?

    init(configuration: ChartConfiguration? = nil) {
        if let configuration = configuration {
            apply(configuration: configuration)
        }
    }

    @discardableResult func apply(configuration: ChartConfiguration) -> Self {
        self.configuration = configuration

        rsi.strokeColor = configuration.rsiLineColor
        rsi.animationStyle = .strokeEnd
        rsi.padding = configuration.rsiPadding
        rsi.animationDuration = configuration.animationDuration

        rsiLimitLines.strokeColor = configuration.limitLinesColor
        rsiLimitLines.lineWidth = configuration.limitLinesWidth
        rsiLimitLines.lineDashPattern = configuration.limitLinesDashPattern
        rsiLimitLines.padding = configuration.rsiPadding
        rsiLimitLines.set(points: [CGPoint(x: 0, y: configuration.rsiBottomLimitValue), CGPoint(x: 0, y: configuration.rsiTopLimitValue)])

        rsiTopValue.textColor = configuration.limitTextColor
        rsiTopValue.font = configuration.limitTextFont
        rsiTopValue.insets = configuration.highLimitTextInsets
        rsiTopValue.size = configuration.highLimitTextSize

        rsiBottomValue.textColor = configuration.limitTextColor
        rsiBottomValue.font = configuration.limitTextFont
        rsiBottomValue.insets = configuration.lowLimitTextInsets
        rsiBottomValue.size = configuration.lowLimitTextSize

        rsiTopValue.set(text: "\(configuration.rsiTopLimitValue * 100)")
        rsiBottomValue.set(text: "\(configuration.rsiBottomLimitValue * 100)")

        return self
    }

    @discardableResult func add(to chart: Chart) -> Self {
        chart.add(rsi)
        chart.add(rsiLimitLines)
        chart.add(rsiTopValue)
        chart.add(rsiBottomValue)

        return self
    }

    func set(points: [CGPoint]?, animated: Bool) {
        rsi.set(points: points ?? [], animated: animated)
    }

    func set(hidden: Bool) {
        rsi.layer.isHidden = hidden
        rsiLimitLines.layer.isHidden = hidden
        rsiTopValue.layer.isHidden = hidden
        rsiBottomValue.layer.isHidden = hidden
    }

    func set(selected: Bool) {
        // dont change colors
    }

}
