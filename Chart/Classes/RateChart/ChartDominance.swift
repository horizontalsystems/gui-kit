import UIKit

class ChartDominance {
    private let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    private let dominance = ChartLine()

    private let valueText = ChartText()
    private let diffText = ChartText()

    private var configuration: ChartConfiguration?

    init(configuration: ChartConfiguration? = nil) {
        if let configuration = configuration {
            apply(configuration: configuration)
        }
    }

    @discardableResult func apply(configuration: ChartConfiguration) -> Self {
        self.configuration = configuration

        dominance.strokeColor = configuration.dominanceLineColor
        dominance.lineWidth = configuration.dominanceLineWidth
        dominance.animationStyle = .strokeEnd
        dominance.padding = configuration.curvePadding
        dominance.animationDuration = configuration.animationDuration


        valueText.textColor = configuration.dominanceTextColor
        valueText.font = configuration.dominanceTextFont
        valueText.textAlignment = .right
        valueText.insets = configuration.dominanceInsets
        valueText.size = configuration.dominanceSize
        valueText.set(text: configuration.dominanceTextPrefix)

        diffText.font = configuration.dominanceDiffTextFont
        diffText.textAlignment = .right
        diffText.insets = configuration.dominanceDiffInsets
        diffText.size = configuration.dominanceDiffSize

        return self
    }

    @discardableResult func add(to chart: Chart) -> Self {
        chart.add(dominance)

        chart.add(valueText)
        chart.add(diffText)

        return self
    }

    func set(values: [CGPoint]?, diff: [CGPoint]?, animated: Bool) {
        dominance.set(points: values ?? [], animated: animated)
    }

    func set(hidden: Bool) {
        dominance.layer.isHidden = hidden
        valueText.layer.isHidden = hidden
        diffText.layer.isHidden = hidden
    }

    func setLast(value: Decimal?, diff: Decimal?) {
        if let diff = diff, let configuration = configuration {
            diffText.textColor = diff < 0 ? configuration.dominanceDiffNegativeColor : configuration.dominanceDiffPositiveColor
        }

        let correctedDominance = value.flatMap { format(percentValue: $0) }
        let correctedDiff = diff.flatMap { format(percentValue: $0, signed: true) }

        let dominanceText = ([configuration?.dominanceTextPrefix, correctedDominance].compactMap { $0 }).joined(separator: " ")
        valueText.set(text: dominanceText)

        diffText.set(text: correctedDiff)
    }

    func set(selected: Bool) {
        // don't change colors
    }

    private func format(percentValue: Decimal, signed: Bool = true) -> String? {
        let plusSign = (percentValue > 0 && signed) ? "+" : ""

        let formattedDiff = percentFormatter.string(from: percentValue as NSNumber)
        return formattedDiff.map { plusSign + $0 + "%" }
    }

}
