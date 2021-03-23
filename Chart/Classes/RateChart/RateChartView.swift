import UIKit
import SnapKit

public protocol IChartViewTouchDelegate: class {
    func touchDown()
    func select(item: ChartItem)
    func touchUp()
}

public class RateChartView: UIView {
    private let mainChart = MainChart()
    private let indicatorChart = IndicatorChart()
    private let timelineChart = TimelineChart()
    private let chartTouchArea = ChartTouchArea()

    private let emaShort = ChartLine()
    private let emaLong = ChartLine()

    private let chartEma = ChartEma()
    private let chartMacd = ChartMacd()
    private let chartRsi = ChartRsi()

    private var lineColor: UIColor = .clear
    private var configuration: ChartConfiguration?

    public weak var delegate: IChartViewTouchDelegate?

    private var chartData: ChartData?

    public init(configuration: ChartConfiguration? = nil) {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true

        addSubview(mainChart)
        addSubview(indicatorChart)
        addSubview(timelineChart)
        addSubview(chartTouchArea)

        if let configuration = configuration {
            apply(configuration: configuration)
        }
    }

    @discardableResult public func apply(configuration: ChartConfiguration) -> Self {
        self.configuration = configuration

        backgroundColor = configuration.backgroundColor

        mainChart.snp.makeConstraints { maker in
            maker.leading.top.trailing.equalToSuperview()
            maker.height.equalTo(configuration.mainHeight)
        }
        mainChart.apply(configuration: configuration)

        indicatorChart.snp.makeConstraints { maker in
            maker.bottom.equalTo(mainChart.snp.bottom)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(configuration.indicatorHeight)
        }
        indicatorChart.apply(configuration: configuration)

        timelineChart.snp.makeConstraints { maker in
            maker.top.equalTo(indicatorChart.snp.bottom)
            maker.leading.bottom.trailing.equalToSuperview()
            maker.height.equalTo(configuration.timelineHeight)
        }
        timelineChart.apply(configuration: configuration)

        chartTouchArea.snp.makeConstraints { maker in
            maker.leading.top.trailing.equalToSuperview()
            maker.bottom.equalTo(indicatorChart.snp.bottom)
        }
        chartTouchArea.apply(configuration: configuration)
        chartTouchArea.delegate = self

        chartEma.add(to: mainChart).apply(configuration: configuration)
        chartMacd.add(to: indicatorChart).apply(configuration: configuration)
        chartRsi.add(to: indicatorChart).apply(configuration: configuration)

        chartEma.set(hidden: true)
        chartMacd.set(hidden: true)
        chartRsi.set(hidden: true)

        layoutIfNeeded()

        return self
    }


    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    public func set(chartData: ChartData, animated: Bool = true) {
        self.chartData = chartData

        let converted = RelativeConverter.convert(chartData: chartData)

        if let points = converted[.rate] {
            mainChart.set(points: points, animated: animated)
            chartTouchArea.set(points: points)
        }
        indicatorChart.set(volumes: converted[.volume] ?? [], animated: animated)

        chartEma.set(short: converted[.emaShort], long: converted[.emaLong], animated: animated)
        chartMacd.set(macd: converted[.macd], macdHistogram: converted[.macdHistogram], macdSignal: converted[.macdSignal], animated: animated)
        chartRsi.set(points: converted[.rsi], animated: true)
    }

    public func setCurve(color: UIColor) {
        lineColor = color
        mainChart.setLine(color: color)
    }

    public func set(timeline: [ChartTimelineItem], start: TimeInterval, end: TimeInterval) {
        let delta = end - start
        let positions = timeline.map {
            CGPoint(x: CGFloat(($0.timestamp - start) / delta), y: 0)
        }

        mainChart.setVerticalLines(points: positions)
        indicatorChart.setVerticalLines(points: positions)

        timelineChart.set(texts: timeline.map { $0.text }, positions: positions)
    }

    public func setVolumes(hidden: Bool) {
        indicatorChart.setVolumes(hidden: hidden)
    }

    public func setEma(hidden: Bool) {
        chartEma.set(hidden: hidden)
    }

    public func setMacd(hidden: Bool) {
        chartMacd.set(hidden: hidden)
    }

    public func setRsi(hidden: Bool) {
        chartRsi.set(hidden: hidden)
    }

    public func setLimits(hidden: Bool) {
        mainChart.setLimits(hidden: hidden)
    }

    public func set(highLimitText: String?, lowLimitText: String?) {
        mainChart.set(highLimitText: highLimitText, lowLimitText: lowLimitText)
    }

}

extension RateChartView: ITouchAreaDelegate {

    func touchDown() {
        guard let configuration = configuration else {
            return
        }

        mainChart.setLine(color: configuration.selectedColor)

        chartEma.set(selected: true)
        chartMacd.set(selected: true)
        chartRsi.set(selected: true)

        delegate?.touchDown()
    }

    func select(at index: Int) {
        guard let data = chartData,
              index < data.items.count,
              let item = chartData?.items[index] else {

            return
        }

        delegate?.select(item: item)
    }

    func touchUp() {
        mainChart.setLine(color: lineColor)

        chartEma.set(selected: false)
        chartMacd.set(selected: false)
        chartRsi.set(selected: false)

        delegate?.touchUp()
    }

}
