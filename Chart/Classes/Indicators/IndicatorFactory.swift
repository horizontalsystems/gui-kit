import Foundation

public enum ChartIndicatorType: String, CaseIterable {
    case emaShort = "ema_short"
    case emaLong = "ema_long"
    case macd = "macd"
    case rsi = "rsi"
}

public enum ChartIndicatorName: String {
    case rate = "rate"
    case volume = "volume"
    case ma = "ma"
    case emaShort = "ema_short"
    case emaLong = "ema_long"
    case macd = "macd"
    case macdSignal = "macd_signal"
    case macdHistogram = "macd_histogram"
    case rsi = "rsi"
    case dominance = "dominance"
}

public protocol IIndicatorFactory {
    func indicatorData(type: ChartIndicatorType, values: [Decimal]) -> [ChartIndicatorName: [Decimal]]
    func indicatorLast(type: ChartIndicatorType, values: [Decimal]) -> [ChartIndicatorName: Decimal]
}

public class IndicatorFactory: IIndicatorFactory {

    public func indicatorData(type: ChartIndicatorType, values: [Decimal]) -> [ChartIndicatorName: [Decimal]] {
        var data = [ChartIndicatorName: [Decimal]]()

        switch type {
        case .emaShort:
            data[.emaShort] = ChartIndicators.ma(period: 25, values: values)
        case .emaLong:
            data[.emaLong] = ChartIndicators.ema(period: 50, values: values)
        case .macd:
            let macd = ChartIndicators.macd(fast: 12, long: 26, signal: 9, values: values)
            data[.macd] = macd.macd
            data[.macdSignal] = macd.signal
            data[.macdHistogram] = macd.histogram
        case .rsi:
            data[.rsi] = ChartIndicators.rsi(period: 12, values: values)
        }

        return data
    }

    public func indicatorLast(type: ChartIndicatorType, values: [Decimal]) -> [ChartIndicatorName: Decimal] {
        let data = indicatorData(type: type, values: values)
        var last = [ChartIndicatorName: Decimal]()

        data.forEach { key, values in
            if let lastValue = values.last {
                last[key] = lastValue
            }
        }

        return  last
    }

    public init() {
    }

}
