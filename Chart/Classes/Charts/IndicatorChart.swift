import UIKit

class IndicatorChart: Chart {
    private let border = ChartBorder()
    private let volumeBars = ChartBars()
    private let verticalLines = ChartGridLines()

    init(configuration: ChartConfiguration? = nil) {
        super.init(frame: .zero)

        add(border)
        add(volumeBars)
        add(verticalLines)

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

        volumeBars.barFillColor = configuration.volumeBarsFillColor
        volumeBars.strokeColor = configuration.volumeBarsColor
        volumeBars.padding = configuration.volumeBarsInsets
        volumeBars.animationDuration = configuration.animationDuration

        verticalLines.gridType = .vertical
        verticalLines.lineDirection = .top
        verticalLines.lineWidth = configuration.verticalLinesWidth
        verticalLines.strokeColor = configuration.verticalLinesColor
        verticalLines.invisibleIndent = configuration.verticalInvisibleIndent

        return self
    }

    func set(volumes: [CGPoint]?, animated: Bool = false) {
        volumeBars.set(points: volumes ?? [], animated: animated)
    }

    func setVolumeColor(color: UIColor) {
        volumeBars.barFillColor = color
    }


    func setVolumes(hidden: Bool) {
        volumeBars.layer.isHidden = hidden
    }

    func setVerticalLines(points: [CGPoint], animated: Bool = false) {
        verticalLines.set(points: points, animated: animated)
    }

    func setVerticalLines(hidden: Bool) {
        verticalLines.layer.isHidden = hidden
    }

}
