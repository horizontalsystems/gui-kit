import UIKit

class ChartVolumeView: UIView {
    private let configuration: ChartConfiguration
    public weak var dataSource: IChartDataSource?
    private let pointConverter: IPointConverter

    private let barsLayer = CAShapeLayer()

    private var lastBarsPath: UIBezierPath? = nil
    private var animated: Bool = false

    public init(configuration: ChartConfiguration, pointConverter: IPointConverter) {
        self.configuration = configuration
        self.pointConverter = pointConverter

        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Can't init with aDecoder")
    }

    override var frame: CGRect {
        didSet {
            barsLayer.frame = bounds
            refreshBars(animated: animated)
        }
    }

    override var bounds: CGRect {
        didSet {
            barsLayer.frame = bounds
            refreshBars(animated: animated)
        }
    }

    private func commonInit() {
        clipsToBounds = true

        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale

        barsLayer.fillColor = configuration.volumeBarColor.cgColor
        layer.addSublayer(barsLayer)
    }

    func refreshBars(animated: Bool) {
        self.animated = animated
        guard !bounds.isEmpty, let dataSource = dataSource, !dataSource.chartData.isEmpty else {
            return
        }
        barsLayer.sublayers?.removeAll()

        var chunks = [ChartPoint]()
        let chartData = dataSource.chartData
        let maxVolume: Decimal = chartData.compactMap { $0.volume }.max() ?? 0     // get maximum volume to calculate converting Y delta
        guard !maxVolume.isZero else {
            return
        }

        let deltaX = bounds.maxX / CGFloat(dataSource.chartFrame.width)
        let deltaY = bounds.maxY / maxVolume.cgFloatValue

        let startPath = UIBezierPath()                                      // path with 0 bars to animate from new volumes to current
        let completeBarsPath = UIBezierPath()                               // calculated path for bars

        for point in chartData {
            guard let volume = point.volume else {
                continue
            }

            let y = ceil(bounds.maxY - volume.cgFloatValue * deltaY)                                // volume converted to Y coordinate
            let startX = CGFloat(point.timestamp - dataSource.chartFrame.left) * deltaX - configuration.volumeBarWidth  // finish timestamp converted to X coordinate

            completeBarsPath.append(UIBezierPath(rect: CGRect(x: startX, y: y, width: configuration.volumeBarWidth, height: bounds.maxY - y)))

            if animated, lastBarsPath == nil {
                startPath.append(UIBezierPath(rect: CGRect(x: startX, y: bounds.maxY, width: configuration.volumeBarWidth, height: bounds.maxY)))
            }
        }

        guard animated else {                                       // if not animated just set path and draw
            barsLayer.removeAllAnimations()

            lastBarsPath = completeBarsPath
            return
        }
        // animate

        CATransaction.begin()                                       // make animations from zero path if no lastPath or from lastPath if exist

        let barsAnimation = animation(startPath: (lastBarsPath ?? startPath).cgPath, finishPath: completeBarsPath.cgPath)
        barsLayer.add(barsAnimation, forKey: "barsAnimation")

        CATransaction.setCompletionBlock { [weak self] in
            self?.lastBarsPath = completeBarsPath
        }

        CATransaction.commit()
    }

    private func animation(startPath: CGPath, finishPath: CGPath) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = startPath
        animation.toValue = finishPath
        animation.duration = configuration.animationDuration
        animation.isRemovedOnCompletion = false
        animation.fillMode = .both
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)

        return animation
    }

}
