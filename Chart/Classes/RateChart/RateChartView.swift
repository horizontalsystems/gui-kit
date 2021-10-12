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

    private let chartEma = ChartEma()
    private let chartMacd = ChartMacd()
    private let chartRsi = ChartRsi()
    private let chartDominance = ChartDominance()

    private var colorType: ChartColorType = .neutral
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
        if configuration.isInteractive {
            chartTouchArea.delegate = self
        }

        if configuration.showIndicators {
            chartEma.add(to: mainChart).apply(configuration: configuration)
            chartMacd.add(to: indicatorChart).apply(configuration: configuration)
            chartRsi.add(to: indicatorChart).apply(configuration: configuration)

            chartEma.set(hidden: true)
            chartMacd.set(hidden: true)
            chartRsi.set(hidden: true)
        }

        if configuration.showDominance {
            chartDominance.add(to: mainChart).apply(configuration: configuration)
        }


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

        chartDominance.set(values: converted[.dominance], animated: animated)
        if let firstDominance = chartData.items.first?.indicators[.dominance], let lastDominance = chartData.items.last?.indicators[.dominance] {
            chartDominance.setLast(value: lastDominance, diff: (lastDominance - firstDominance) / firstDominance * 100)
        }
    }

    public func setCurve(colorType: ChartColorType) {
        guard configuration != nil else {
            return
        }
        self.colorType = colorType
        mainChart.setLine(colorType: colorType)
    }

    public func set(timeline: [ChartTimelineItem], start: TimeInterval, end: TimeInterval) {
        let delta = end - start
        guard !delta.isZero else {
            return
        }
        let positions = timeline.map {
            CGPoint(x: CGFloat(($0.timestamp - start) / delta), y: 0)
        }

        mainChart.setVerticalLines(points: positions)

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

    public func setDominance(hidden: Bool) {
        chartDominance.set(hidden: hidden)
    }

    public func setDominanceLast(value: Decimal?, diff: Decimal?) {
        chartDominance.setLast(value: value, diff: diff)
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
        guard configuration != nil else {
            return
        }

        mainChart.setLine(colorType: .pressed)

        chartEma.set(selected: true)
        chartMacd.set(selected: true)
        chartRsi.set(selected: true)
        chartDominance.set(selected: true)

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
        mainChart.setLine(colorType: colorType)

        chartEma.set(selected: false)
        chartMacd.set(selected: false)
        chartRsi.set(selected: false)
        chartDominance.set(selected: false)

        delegate?.touchUp()
    }

}
