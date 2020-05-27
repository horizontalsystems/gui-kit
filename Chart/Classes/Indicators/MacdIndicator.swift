// TODO: refactor indicator factory
//import Foundation
//
//class MacdIndicator {
//    private let indicatorFactory: IndicatorFactory
//    private let fast: Int
//    private let long: Int
//    private let signal: Int
//
//    init(indicatorFactory: IndicatorFactory, fast: Int, long: Int, signal: Int) {
//        self.indicatorFactory = indicatorFactory
//        self.fast = fast
//        self.long = long
//        self.signal = signal
//    }
//
//    func calculate(values: [Decimal]) -> [ChartIndicatorName: [Decimal]] {
//        let diff = long - fast
//        guard diff > 0 else {
//            return [:]
//        }
//
//        let emaFastDictionary = indicatorFactory.ema(period: fast).calculate(values: values)[.emaShort]
//        let emaLongDictionary = indicatorFactory.ema(period: long).calculate(values: values)[.emaShort]
//
//        guard let emaFast = emaFastDictionary,
//            let emaLong = emaLongDictionary else {
//            return [:]
//        }
//
//        let macd = emaLong.enumerated().compactMap { (index, longValue) in
//            emaFast[index + diff] - longValue
//        }
//        guard let emaSignal = indicatorFactory.ema(period: signal).calculate(values: macd)[.emaShort] else {
//            return [:]
//        }
//
//        let signalDiff = macd.count - emaSignal.count
//        let histogram: [Decimal]
//
//        histogram = emaSignal.enumerated().compactMap { (index, signal) in
//            macd[index + signalDiff] - signal
//        }
//
//        return [.macd: macd, .macdSignal: emaSignal, .macdHistogram: histogram]
//    }
//
//}
