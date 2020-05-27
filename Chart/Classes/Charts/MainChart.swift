import UIKit

class MainChart: Chart {
    private let border = ChartBorder()
    private let curve = ChartLine()
    private let gradient = ChartLineBottomGradient()
    private let horizontalLines = ChartGridLines()
    private let verticalLines = ChartGridLines()
    private let highLimitText = ChartText()
    private let lowLimitText = ChartText()

    init(configuration: ChartConfiguration? = nil) {
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
        border.lineWidth = configuration.borderWidth
        border.strokeColor = configuration.borderColor

        curve.padding = configuration.curvePadding
        curve.animationDuration = configuration.animationDuration

        gradient.gradientAlphaPositions = configuration.gradientAlphaPositions
        gradient.padding = configuration.curvePadding
        gradient.animationDuration = configuration.animationDuration

        horizontalLines.gridType = .horizontal
        horizontalLines.lineWidth = configuration.limitLinesWidth
        horizontalLines.lineDashPattern = configuration.limitLinesDashPattern
        horizontalLines.strokeColor = configuration.limitLinesColor
        horizontalLines.padding = configuration.limitLinesPadding
        horizontalLines.set(points: [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 1)])

        verticalLines.gridType = .vertical
        verticalLines.lineDirection = .top
        verticalLines.lineWidth = configuration.verticalLinesWidth
        verticalLines.strokeColor = configuration.verticalLinesColor
        verticalLines.invisibleIndent = configuration.verticalInvisibleIndent

        highLimitText.textColor = configuration.limitTextColor
        highLimitText.font = configuration.limitTextFont
        highLimitText.insets = configuration.highLimitTextInsets
        highLimitText.size = configuration.highLimitTextSize

        lowLimitText.textColor = configuration.limitTextColor
        lowLimitText.font = configuration.limitTextFont
        lowLimitText.insets = configuration.lowLimitTextInsets
        lowLimitText.size = configuration.lowLimitTextSize

        return self
    }

    func set(points: [CGPoint], animated: Bool = false) {
        curve.set(points: points, animated: animated)
        gradient.set(points: points, animated: animated)
    }

    func set(highLimitText: String?, lowLimitText: String?) {
        self.highLimitText.set(text: highLimitText)
        self.lowLimitText.set(text: lowLimitText)
    }

    func setLine(color: UIColor) {
        curve.strokeColor = color
        gradient.gradientColor = color
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
