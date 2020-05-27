import UIKit

class ChartMacd {
    private let macdHistogram = ChartHistogram()
    private let macdSignal = ChartLine()
    private let macd = ChartLine()

    private let shortText = ChartText()
    private let longText = ChartText()
    private let signalText = ChartText()

    private var configuration: ChartConfiguration?

    init(configuration: ChartConfiguration? = nil) {
        if let configuration = configuration {
            apply(configuration: configuration)
        }
    }

    @discardableResult func apply(configuration: ChartConfiguration) -> Self {
        self.configuration = configuration

        macdHistogram.positiveBarFillColor = configuration.macdPositiveColor
        macdHistogram.negativeBarFillColor = configuration.macdNegativeColor
        macdHistogram.insets = configuration.macdHistogramInsets
        macdHistogram.animationDuration = configuration.animationDuration

        macdSignal.strokeColor = configuration.macdSignalColor
        macdSignal.padding = configuration.macdLinesInsets
        macdSignal.animationDuration = configuration.animationDuration

        macd.strokeColor = configuration.macdColor
        macd.padding = configuration.macdLinesInsets
        macd.animationDuration = configuration.animationDuration

        shortText.textColor = configuration.macdTextColor.withAlphaComponent(0.5)
        shortText.font = configuration.macdTextFont
        shortText.insets = configuration.macdShortInsets
        shortText.size = configuration.macdShortSize
        shortText.set(text: configuration.macdShortText)

        longText.textColor = configuration.macdTextColor.withAlphaComponent(0.5)
        longText.font = configuration.macdTextFont
        longText.insets = configuration.macdLongInsets
        longText.size = configuration.macdLongSize
        longText.set(text: configuration.macdLongText)

        signalText.textColor = configuration.macdTextColor.withAlphaComponent(0.5)
        signalText.font = configuration.macdTextFont
        signalText.insets = configuration.macdSignalInsets
        signalText.size = configuration.macdSignalSize
        signalText.set(text: configuration.macdSignalText)

        return self
    }

    @discardableResult func add(to chart: Chart) -> Self {
        chart.add(macdHistogram)
        chart.add(macdSignal)
        chart.add(macd)
        chart.add(shortText)
        chart.add(longText)
        chart.add(signalText)

        return self
    }

    func set(macd: [CGPoint]?, macdHistogram: [CGPoint]?, macdSignal: [CGPoint]?, animated: Bool) {
        self.macd.set(points: macd ?? [], animated: animated)
        self.macdHistogram.set(points: macdHistogram ?? [], animated: animated)
        self.macdSignal.set(points: macdSignal ?? [], animated: animated)
    }

    func set(hidden: Bool) {
        macd.layer.isHidden = hidden
        macdHistogram.layer.isHidden = hidden
        macdSignal.layer.isHidden = hidden

        shortText.layer.isHidden = hidden
        longText.layer.isHidden = hidden
        signalText.layer.isHidden = hidden
    }

    func set(selected: Bool) {
        guard let configuration = configuration else {
            return
        }

        macdHistogram.negativeBarFillColor = selected ? configuration.macdSelectedColor : configuration.macdNegativeColor
        macdHistogram.positiveBarFillColor = selected ? configuration.macdSelectedColor : configuration.macdPositiveColor
    }

}
