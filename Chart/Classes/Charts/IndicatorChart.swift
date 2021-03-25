import UIKit

class IndicatorChart: Chart {
    private let volumeBars = ChartBars()

    init(configuration: ChartConfiguration? = nil) {
        super.init(frame: .zero)

        add(volumeBars)

        if let configuration = configuration {
            apply(configuration: configuration)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @discardableResult func apply(configuration: ChartConfiguration) -> Self {
        volumeBars.barFillColor = configuration.volumeBarsFillColor
        volumeBars.strokeColor = configuration.volumeBarsColor
        volumeBars.padding = configuration.volumeBarsInsets
        volumeBars.animationDuration = configuration.animationDuration

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

}
