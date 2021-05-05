import UIKit

private class ChartRange {
    var min: Decimal
    var max: Decimal

    init(min: Decimal, max: Decimal) {
        self.min = min
        self.max = max
    }

}

class RelativeConverter {

    static private func ranges(chartData: ChartData) -> [ChartIndicatorName: ChartRange] {
        var ranges = [ChartIndicatorName: ChartRange]()

        // calculate ranges for all indicators
        for item in chartData.items {
            for (key, value) in item.indicators {
                guard let range = ranges[key] else {
                    ranges[key] = ChartRange(min: value, max: value)
                    continue
                }
                if value < range.min {
                    range.min = value
                }
                if value > range.max {
                    range.max = value
                }
            }
        }
        // set ranges for volume : from 0 to max
        if let volumeRange = ranges[.volume] {
            ranges[.volume] = ChartRange(min: 0, max: volumeRange.max)
        }

        // set ranges for ema : relative rate chart
        if let rateRange = ranges[.rate] {
            ranges[.emaShort] = rateRange
            ranges[.emaLong] = rateRange
        }

        // merge ranges for macd : to show all lines and zoom histogram to maximum
        if let macdRange = ranges[.macd],
           let signalRange = ranges[.macdSignal],
           let histogramRange = ranges[.macdHistogram] {

            let lineAbs = [macdRange.min, macdRange.max,
                           signalRange.min, signalRange.max,
                           histogramRange.min, histogramRange.max]
                .map { abs($0) }
                .max() ?? 0
            let commonRange = ChartRange(min: -lineAbs, max: lineAbs)
            ranges[.macd] = commonRange
            ranges[.macdSignal] = commonRange

            let histogramAbs = [histogramRange.min, histogramRange.max]
                .map { abs($0) }
                .max() ?? 0
            ranges[.macdHistogram] = ChartRange(min: -histogramAbs, max: histogramAbs)
        }
        // range for RSI : 0 to 100
        ranges[.rsi] = ChartRange(min: 0, max: 100)

        return ranges
    }

    static private func relative(chartData: ChartData, ranges: [ChartIndicatorName: ChartRange]) -> [ChartIndicatorName: [CGPoint]] {
        let timestampDelta = chartData.endWindow - chartData.startWindow
        guard !timestampDelta.isZero else {
            return [:]
        }
        var relativeData = [ChartIndicatorName: [CGPoint]]()

        for item in chartData.items {
            let timestamp = item.timestamp - chartData.startWindow
            let x = CGFloat(timestamp / timestampDelta)

            for (key, value) in item.indicators {
                guard let range = ranges[key] else {
                    continue
                }

                let delta = range.max - range.min
                let y = delta == 0 ? 0.5 : ((value - range.min) / delta).cgFloatValue
                let point = CGPoint(x: x, y: y)

                guard relativeData[key] != nil else {
                    var points = [CGPoint]()
                    points.append(point)

                    relativeData[key] = points
                    continue
                }

                relativeData[key]?.append(point)
            }
        }

        return relativeData
    }

    static func convert(chartData: ChartData) -> [ChartIndicatorName: [CGPoint]] {

        // calculate ranges for all data
        let indicatorRanges = ranges(chartData: chartData)
        // make relative points
        return relative(chartData: chartData, ranges: indicatorRanges)
    }

}
