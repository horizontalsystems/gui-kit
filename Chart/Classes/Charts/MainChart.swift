import UIKit

class MainChart: Chart {
    private let border = ChartBorder()
    private let curve = ChartLine()
    private let gradient = ChartLineBottomGradient()
    private let horizontalLines = ChartGridLines()
    private let verticalLines = ChartGridLines()
    private let highLimitText = ChartText()
    private let lowLimitText = ChartText()

    private var configuration: ChartConfiguration?

    init(configuration: ChartConfiguration? = nil) {
        self.configuration = configuration

        super.init(frame: .zero)

        add(border)
        add(curve)
        add(gradient)
        add(horizontalLines)
        add(verticalLines)
        add(highLimitText)
        add(lowLimitText)

        if let configuration = configuration {
            apply(configuration: configuration)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @discardableResult func apply(configuration: ChartConfiguration) -> Self {
        self.configuration = configuration

        if configuration.showBorders {
            border.lineWidth = configuration.borderWidth
        }

        curve.padding = configuration.curvePadding
        curve.animationDuration = configuration.animationDuration

        gradient.padding = configuration.curvePadding
        gradient.animationDuration = configuration.animationDuration

        if configuration.showLimits {
            horizontalLines.gridType = .horizontal
            horizontalLines.lineWidth = configuration.limitLinesWidth
            horizontalLines.lineDashPattern = configuration.limitLinesDashPattern
            horizontalLines.padding = configuration.limitLinesPadding
            horizontalLines.set(points: [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 1)])

            highLimitText.font = configuration.limitTextFont
            highLimitText.insets = configuration.highLimitTextInsets
            highLimitText.size = configuration.highLimitTextSize

            lowLimitText.font = configuration.limitTextFont
            lowLimitText.insets = configuration.lowLimitTextInsets
            lowLimitText.size = configuration.lowLimitTextSize
        }

        if configuration.showVerticalLines {
            verticalLines.gridType = .vertical
            verticalLines.lineDirection = .top
            verticalLines.lineWidth = configuration.verticalLinesWidth
            verticalLines.invisibleIndent = configuration.verticalInvisibleIndent
        }


        updateUI()

        return self
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        updateUI()
    }

    private func updateUI() {
        guard let configuration = configuration else {
            return
        }

        if configuration.showBorders {
            border.strokeColor = configuration.borderColor
        }

        horizontalLines.strokeColor = configuration.limitLinesColor
        verticalLines.strokeColor = configuration.verticalLinesColor
        highLimitText.textColor = configuration.limitTextColor
        lowLimitText.textColor = configuration.limitTextColor
    }

    func set(points: [CGPoint], animated: Bool = false) {
        curve.set(points: points, animated: animated)
        gradient.set(points: points, animated: animated)
    }

    func set(highLimitText: String?, lowLimitText: String?) {
        self.highLimitText.set(text: highLimitText)
        self.lowLimitText.set(text: lowLimitText)
    }

    func setLine(colorType: ChartColorType) {
        guard let configuration = configuration else {
            return
        }

        curve.strokeColor = colorType.curveColor(configuration: configuration)
        gradient.gradientColors = zip(colorType.gradientColors(configuration: configuration), configuration.gradientAlphas).map { $0.withAlphaComponent($1) }
    }

    func setGradient(hidden: Bool) {
        gradient.layer.isHidden = hidden
    }

    func setLimits(hidden: Bool) {
        horizontalLines.layer.isHidden = hidden
        highLimitText.layer.isHidden = hidden
        lowLimitText.layer.isHidden = hidden
    }

    func setVerticalLines(points: [CGPoint], animated: Bool = false) {
        verticalLines.set(points: points, animated: animated)
    }

    func setVerticalLines(hidden: Bool) {
        verticalLines.layer.isHidden = hidden
    }

}

public enum ChartColorType {
    case up, down, neutral, pressed

    func curveColor(configuration: ChartConfiguration) -> UIColor {
        switch self {
        case .up: return configuration.trendUpColor
        case .down: return configuration.trendDownColor
        case .pressed: return configuration.pressedColor
        case .neutral: return configuration.outdatedColor
        }
    }

    func gradientColors(configuration: ChartConfiguration) -> [UIColor] {
        switch self {
        case .up: return configuration.trendUpGradient
        case .down: return configuration.trendDownGradient
        case .pressed: return configuration.pressedGradient
        case .neutral: return configuration.neutralGradient
        }
    }

}
